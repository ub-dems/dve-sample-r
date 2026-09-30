#!/usr/bin/env python
# coding: utf-8

# In[1]:

import logging
import sys
from argparse import ArgumentParser, Namespace, RawTextHelpFormatter
from datetime import datetime

import dve.demo.dummy.greeter as dmy
from vce.common.util.kernel import in_notebook

# In[2]:

# In[3]:

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__name__)

# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[4]:

RC = 0

TIME_START = datetime.now()

ARGV_DEFAULT = [
    "--salutation",
    "Hello",
    # "--who",  # use argparse default
    # "World",
    "--n-points",
    "3",
]

ARGV_NOTEBOOK = ARGV_DEFAULT

# -----
args = None

# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[4]:

TRACE = False


def get_dummy_argparser(*argv, **kwargs) -> ArgumentParser:

    if TRACE:
        log.debug(">> ### main(argv=%s), (kvargv=%s)", str(argv), str(kwargs))

    parser = ArgumentParser(
        add_help=True,
        conflict_handler="resolve",
        formatter_class=RawTextHelpFormatter,
        description="""

    dummy_script: "Hello World" demo

    - internally (./runtime.sh sh), run as:
        poetry run hello [  -s Hi -w Moon -n 5 ]

    - externally, run as:
        ./runtime.sh py hello [  -s Hi -w Moon -n 5 ]

    NOTE:

    - requires:
        poetry install

    - externally:
        ./runtime.sh sh poetry install

    """,
    )

    parser.add_argument(
        "--who",
        "-w",
        type=str,
        default="World",
        help="Who in greetings",
    )
    parser.add_argument(
        "--salutation",
        "-s",
        type=str,
        default="Hi",
        help="Salutation in greetings",
    )
    parser.add_argument(
        "--n-points",
        "-n",
        type=int,
        default=0,
        help="Number of emoji for greetings",
    )
    parser.add_argument(
        "--verbose",
        "-v",
        action="count",
        default=0,
        help="increase output verbosity",
    )
    return parser


def get_argv(argv: list[str] | None) -> list[str]:
    if argv is not None:
        return argv
    if in_notebook():
        return ARGV_NOTEBOOK
    if len(sys.argv) > 1:
        return sys.argv[1:]
    return ARGV_DEFAULT


# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[5]:


def run_worker(args: Namespace) -> int:

    who: str = args.who
    salutation: str = args.salutation
    num_points: int = args.n_points

    greeting = dmy.Greeting(who=who, salutation=salutation)
    greeter = dmy.Greeter(greeting)

    message = greeter.get_message(num_points)

    print(message)

    log.info("== %s", message)

    return RC


# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[6]:


def parse_args(argv: list[str], **kwargs) -> Namespace:
    parser = get_dummy_argparser()
    result = parser.parse_args(argv, **kwargs)
    return result


def exec(args: Namespace) -> int:
    RC = run_worker(args)
    return RC


def main(argv: list[str] | None = None, **kwargs) -> int:

    print(argv)
    print(__name__ + "main:" + str(argv))

    argv = get_argv(argv)

    log.info(">> ### %s.main(argv=%s)", __name__, str(argv))
    args = parse_args(argv=argv, **kwargs)
    RC = exec(args)

    log.info("<< ### %s.main => (rc=%d)", __name__, RC)
    return RC


# //////////////////////////////////////////////////////////////////////////////////////////////////

# In[7]:

if __name__ == "__main__":
    main(sys.argv[1:])
