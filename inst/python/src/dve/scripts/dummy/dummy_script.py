#!/usr/bin/env python
# coding: utf-8

# In[1]:

import argparse
import logging
import sys
from datetime import datetime

import dve.demo.dummy.greeter as dmy
from vce.common.util.kernel import in_notebook

# In[2]:


# In[3]:

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__name__)

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# In[4]:

RC = 0

TIME_START = datetime.now()

ARGV_DEFAULT = [
    "--jobname",
    "_",
    "--group",
    "test",
    "--filename",
]

ARGV_NOTEBOOK = ARGV_DEFAULT

# -----
args = None

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# In[4]:


def get_dummy_argparser(*argv, **kwargs) -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(add_help=False, conflict_handler="resolve")

    parser.add_argument(
        "--salutation",
        "-s",
        type="character",
        default="Hi",
        help="Salutation in greetings [default %default]",
    )
    parser.add_argument(
        "--n-points",
        "-n",
        type="integer",
        default=0,
        help="Number of emoji for greetings [default %default]",
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


# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# In[5]:


def run_worker():

    greeting = dmy.Greeting(who="_who_", salutation="_salutation_")
    greeter = dmy.Greeter(greeting)

    message = greeter.get_message()

    print(message)

    log.info(f"== { message }")

    return RC


# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# In[6]:


def parse_args(argv, **kwargs):
    parser = get_dummy_argparser()
    result = parser.parse_args(argv, **kwargs)
    return result


def exec(argv, xargs, **kwargs):
    global RC
    RC = run_worker()
    return RC


def main(argv, **kwargs):
    global RC
    global xargs

    print(argv)
    print(__name__ + "main:" + str(argv))

    argv = get_argv(argv)

    log.info(">> ### " + __name__ + ".main(argv=" + str(argv) + ")")
    xargs = parse_args(argv=argv, **kwargs)
    RC = exec(argv, xargs, **kwargs)

    log.info("<< ###" + __name__ + ".main => (rc=" + str(RC) + ")")
    return RC


# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# In[7]:

if __name__ == "__main__":
    main(sys.argv[1:])
