import sys
import logging
import platform as pf

from vce.cli.ctl import std_main
from vce.cli.xargs import get_test_argparser


from vce.config.data import cfd

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__name__)

# //////////////////////////////////////////////////////////////////////////////////////////////////

RC_C_FAIL = 1
RC_C_OK = 0

RC = RC_C_OK


def ea(name: str, **kwargs):
    return kwargs[name] if name in kwargs else None


def ep(**kwargs):
    spec = ea("job_spec", **kwargs)
    return spec.parm if spec else None


def do_process(argv, xargs, **kwargs):
    tag = "x-test"
    msgs = [
        f">> @{tag}.file(name=<{__name__}>)",
        f">> @{tag}.args(argv=<{argv!s}>)",
        f">> @{tag}.args(xargs=<{xargs!s}>)",
        f">> @{tag}.args(kwargs=<{kwargs!s}>)",
        f">> @{tag}.spec(job_name=<{ea('job_name', **kwargs)!s}>)",
        f">> @{tag}.spec(job_xargs=<{ea('job_xargs', **kwargs)!s}>)",
        f">> @{tag}.spec(job_spec=<{ea('job_spec', **kwargs)!s}>)",
        f">> @{tag}.spec(job_parm=<{ep(**kwargs)!s}>)",
        f">> @{tag}.data(work=<{cfd().DATA_WORK},home=<{cfd().DATA_HOME}>)",
        f">> @{tag}.data(work=<{cfd().DATA_USER},home=<{cfd().DATA_DNET}>)",
        f">> @{tag}.arch(plat=<{pf.platform()},arch=<{pf.architecture()}>)",
        f">> @{tag}.arch(mach=<{pf.machine()},proc=<{pf.processor()}>)",
        f">> @{tag}.arch(sys=<{pf.system()},uname=<{pf.uname()}>)",
        f">> @{tag}.arch(kver=<{pf.version()},krel=<{pf.release()}>)",
        f">> @{tag}.vers(lang=<{pf.python_version()},impl=<{pf.python_implementation()}>)",
    ]
    msg = "\n\n[[[\n" + "\n".join(msgs) + "\n]]]\n\n"

    for i in range(len(msgs)):
        if i == 0:
            log.info(msgs[i])
        else:
            log.debug(msgs[i])

    print(msg)

    return RC


# //////////////////////////////////////////////////////////////////////////////////////////////////


def parse_args(argv, **kwargs):
    parser = get_test_argparser()
    result = parser.parse_args(argv, **kwargs)
    return result


def exec(argv, xargs, **kwargs):
    RC = do_process(argv, xargs, **kwargs)
    return RC


@std_main(log=log, debug=True)
def main(argv, **kwargs):
    log.info(">> ### %s.main(argv=%s)", __name__, str(argv))
    xargs = parse_args(argv=argv, **kwargs)
    RC = exec(argv, xargs, **kwargs)
    log.info("<< ### %s.main => (rc=%d)", __name__, RC)
    return RC


if __name__ == "__main__":
    main(sys.argv[1:])
