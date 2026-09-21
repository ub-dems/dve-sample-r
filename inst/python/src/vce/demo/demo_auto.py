import sys
import logging

from vce.cli.ctl import std_main
from vce.cli.xargs import get_auto_argparser

import vce.cli.parms as sp


# //////////////////////////////////////////////////////////////////////////////////////////////////

# ---------------------------------------------------------------

import vce.demo.dummy.demo_script as dummy_script
import vce.demo.dummy.demo_test as dummy_test

# ---------------------------------------------------------------

JOB_SPECS = sp.init_specs(
    [
        sp.spec(
            "demo-01",
            "group-demo",
            dummy_script.main,
            sp.parm(p1=1.0, p2="abc", p3=[7, 8, 9]),
        ),
        sp.spec(
            "test-00",
            "test-demo",
            dummy_test.main,
            sp.parm(p1=0.0, p2="xyz", p3=[0, 0, 0]),
        ),
        sp.spec(
            "test-01",
            "test-demo",
            dummy_test.main,
            sp.parm(p1=-1.0, p2="xyz", p3=[1, 2, 3]),
        ),
        sp.spec(
            "test-02",
            "test-demo",
            dummy_test.main,
            sp.parm(p1=-2.0, p2="xyz", p3=[4, 5, 6]),
        ),
    ],
    auto="test-00",
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
    auto_id = JOB_SPECS.get_auto_name(name)
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
