#!/usr/bin/env python
# coding: utf-8

# In[1]:

import pandas as pd

import time
import os
import os.path
import sys
from typing import NamedTuple
from datetime import datetime
from typing import Optional, Any

# In[2]:

from vce.cli.ctl import std_main
from dve.cli.xargs import get_dummy_argparser

from vce.common.util.trace import trace_logger
from vce.common.util.kernel import in_notebook
from vce.common.util.lint import unused


from dve.config.conf import cfg, AppConfigConsts as CK
from dve.config.data import cfd

# In[3]:

import logging

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__name__)
trc = trace_logger("dmy")

# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[4]:

RC = 0
xargs = {}

TIME_START = datetime.now()

TEST_CASE_1_TINY = "test_one-80.csv"
TEST_CASE_1_SMALL = "test_one-1k.csv"
TEST_CASE_1_MEDIUM = "test_one-2k.csv"
TEST_CASE_1_LARGE = "test_one-35k.csv"
TEST_CASE_DEFAULT = TEST_CASE_1_SMALL

ARGV_DEFAULT = [
    "--jobname",
    "_",
    "--group",
    "test",
    "--filename",
    TEST_CASE_DEFAULT,
]

ARGV_NOTEBOOK = ARGV_DEFAULT

# -----
args = None

# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[5]:


def get_argv(argv: Optional[list[str]] = None) -> list[str]:
    if argv is not None:
        return argv
    if in_notebook():
        return ARGV_NOTEBOOK
    if len(sys.argv) > 1:
        return sys.argv[1:]
    return ARGV_DEFAULT


# //////////////////////////////////////////////////////////////////////////////////////////////////


def jobid():
    jobid = os.getenv("X_CORE_JOBID")
    if not jobid:
        return TIME_START.isoformat()
    return jobid


# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[6]:


class Model(NamedTuple):
    spec: dict
    parms: dict


model: Optional[Model] = None


def retrieve_model():
    spec = {}
    parms = {}
    model = Model(spec, parms)
    return model


# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[7]:


class DataConf(NamedTuple):
    dd_jobid: str
    dd_slot: int
    dd_slots: int
    dd_group: str
    dd_filename: str
    dd_path: str
    dd_temp: str
    dd_part: str
    dd_indir: str
    dd_outdir: str
    dd_infile: str
    dd_outfile: str


dd_conf: Optional[DataConf] = None


def arg_jobid(xargs):
    unused(xargs)
    return jobid()


def arg_group(xargs):
    return xargs.group


def arg_filename(xargs):
    arg_filename = xargs.filename

    if arg_filename is not None:
        return arg_filename

    cnf = cfg().get_value(CK.DMY_B_DUMMY_SCRIPT)
    assert cnf is not None
    def_filename = cnf.get(CK.DMY_C_DUMMY_SCRIPT_FILENAME, TEST_CASE_DEFAULT)
    return def_filename


def arg_slotid(xargs):
    unused(xargs)
    return 0


def arg_slotnum(xargs):
    unused(xargs)
    return 1


def config_data() -> DataConf:

    dd_jobid = arg_jobid(xargs)
    dd_slot = arg_slotid(xargs)
    dd_slots = arg_slotnum(xargs)
    dd_group = arg_group(xargs)
    dd_filename = arg_filename(xargs)
    dd_path = f"{cfd().DATA_HOME}/{dd_group}"
    dd_temp = f"{cfd().DATA_TEMP}/{__name__}/{dd_jobid}/{dd_slots}"
    dd_indir = "in"
    dd_outdir = "out"

    dd_part = f"{dd_temp}/{{dd_slot}}/"
    dd_infile = f"{dd_path}/{dd_indir}/{dd_filename}"
    dd_outfile = f"{dd_part}/{dd_indir}/{dd_filename}"

    dd_conf = DataConf(
        dd_jobid=dd_jobid,
        dd_slot=dd_slot,
        dd_slots=dd_slots,
        dd_group=dd_group,
        dd_filename=dd_filename,
        dd_path=dd_path,
        dd_temp=dd_temp,
        dd_part=dd_part,
        dd_indir=dd_indir,
        dd_outdir=dd_outdir,
        dd_infile=dd_infile,
        dd_outfile=dd_outfile,
    )

    return dd_conf


# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[7]:


def ensure_path(filename):
    dir_name = os.path.dirname(filename)
    os.makedirs(dir_name, mode=0o775, exist_ok=True)
    return filename


def load_data(dd_conf: Optional[DataConf] = dd_conf):
    assert dd_conf is not None
    dd_infile = dd_conf.dd_infile
    df = pd.read_csv(dd_infile, sep=";")
    # print (df)
    return df


# In[8]:


class InputData(NamedTuple):
    df: Optional[pd.DataFrame]


in_data: Optional[InputData] = None

df: pd.DataFrame = pd.DataFrame(columns=["null"])


def prepare_data(df=None, model: Optional[Model] = model):
    assert model is not None
    # spec = model.spec
    # parms = model.parms

    in_data = InputData(df=df)
    return in_data


# In[9]:


def evaluate_model(limits, in_data=in_data, model=model, dd_conf: Optional[DataConf] = dd_conf):
    unused(limits)
    t1 = time.time()
    assert model is not None
    assert dd_conf is not None
    assert in_data is not None
    # spec, _parms = model.spec, model.parms
    # df = in_data.df
    results = pd.DataFrame(
        columns=[
            "id",
            "data",
            "prediction",
        ]
    )

    rows = []

    results = results.append(rows, ignore_index=True, sort=False)
    t2 = time.time()
    print(t2 - t1)
    return results


class OutputData(NamedTuple):
    out: Any


out_data: Optional[OutputData] = None


def process_data(in_data=in_data, model=model, dd_conf: Optional[DataConf] = dd_conf) -> OutputData:
    assert dd_conf is not None
    assert in_data is not None
    assert in_data.df is not None
    lim = len(in_data.df)
    with trc:
        out = evaluate_model(lim, in_data=in_data, model=model)
        out_data = OutputData(out=out)
        return out_data


# In[10]:


def save_data(out_data: Optional[OutputData] = out_data, dd_conf: Optional[DataConf] = dd_conf):
    assert dd_conf is not None
    assert out_data is not None

    dd_outfile = dd_conf.dd_outfile
    ensure_path(dd_outfile)

    out = out_data.out
    out.to_csv(dd_outfile, sep=";", index=False, encoding="utf-8-sig")


# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[13]:


def pre_eval():
    model = retrieve_model()
    dd_conf = config_data()
    df = load_data(dd_conf=dd_conf)
    in_data = prepare_data(df=df, model=model)
    return in_data, model, dd_conf


def do_eval(in_data=in_data, model=model, dd_conf: Optional[DataConf] = dd_conf):
    out_data = process_data(in_data=in_data, model=model, dd_conf=dd_conf)
    return out_data


def post_eval(out_data=out_data, dd_conf: Optional[DataConf] = dd_conf):
    save_data(out_data=out_data, dd_conf=dd_conf)


def run_worker():
    in_data, model, dd_conf = pre_eval()
    out_data = do_eval(in_data=in_data, model=model)
    post_eval(out_data=out_data, dd_conf=dd_conf)
    return RC


# //////////////////////////////////////////////////////////////////////////////////////////////////


def parse_args(argv, **kwargs):
    parser = get_dummy_argparser()
    result = parser.parse_args(argv, **kwargs)
    return result


def exec(argv, xargs, **kwargs):
    unused(argv, xargs, kwargs)
    RC = run_worker()
    return RC


@std_main(log=log, debug=True)
def main(argv, **kwargs):

    print(argv)
    print(__name__ + "main:" + str(argv))

    argv = get_argv(argv)

    log.info(">> ### %s.main(argv=%s)", __name__, str(argv))
    xargs = parse_args(argv=argv, **kwargs)
    RC = exec(argv, xargs, **kwargs)

    log.info("<< ### %s.main => (rc=%d)", __name__, RC)
    return RC


# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[14]:

if __name__ == "__main__":
    main(sys.argv[1:])
