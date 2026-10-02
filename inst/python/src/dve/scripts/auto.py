import sys
import logging

from vce.cli.ctl import std_main
from dve.cli.xargs import get_auto_argparser

import dve.cli.parms as sp


# //////////////////////////////////////////////////////////////////////////////////////////////////

# ---------------------------------------------------------------

from dve.scripts.dummy import dummy_script
from dve.scripts.dummy import dummy_test

# ---------------------------------------------------------------

JOB_SPECS = sp.init_specs(
    [
        sp.spec(
            "job-001",
            "group-a",
            dummy_script.main,
            sp.parm(p1=1.0, p2="abc", p3=[1, 2, 3]),
        ),
        sp.spec(
            "test-01",
            "test-auto",
            dummy_test.main,
            sp.parm(p1=1.0, p2="abc", p3=[1, 2, 3]),
        ),
    ],
    auto="job-001",
)

# //////////////////////////////////////////////////////////////////////////////////////////////////

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__name__)


def exec_spec(argv, xargs, name, spec: sp.JobSpec, **kwargs):
    script_main = spec.call.get_main()
    kwargs["job_name"] = name
    kwargs["job_spec"] = spec
    kwargs["job_xargs"] = xargs
    RC = script_main(argv, **kwargs)
    return RC


def auto_dispatch(argv, xargs, name, **kwargs):
    spec = JOB_SPECS.get_job_spec(name)
    return exec_spec(argv, xargs, name, spec, **kwargs)


def auto_exec(argv, xargs, name, **kwargs):
    auto_id = JOB_SPECS.get_auto_name(name=name)
    return auto_dispatch(argv, xargs, auto_id, **kwargs)


# //////////////////////////////////////////////////////////////////////////////////////////////////


def parse_args(argv=None, **kwargs):
    parser = get_auto_argparser()
    result = parser.parse_args(argv, **kwargs)
    return result


def exec(argv, xargs, **kwargs):
    name = xargs.name
    if name == "_":
        name = "auto"

    if name == "auto":
        RC = auto_exec(argv, xargs, name, **kwargs)
    else:
        RC = auto_dispatch(argv, xargs, name, **kwargs)
    return RC


@std_main(log=log, debug=True)
def main(argv=None, **kwargs):
    log.info(">> ### %s.main(argv=%s)", __name__, str(argv))
    xargs = parse_args(argv, **kwargs)
    RC = exec(argv, xargs, **kwargs)
    log.info("<< ### %s.main => (rc=%d)", __name__, RC)
    return RC


if __name__ == "__main__":
    main(sys.argv[1:])
