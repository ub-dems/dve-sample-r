import sys
import logging

import vce.cli
from vce.cli import std_main

logging.basicConfig(level=logging.DEBUG)

log = logging.getLogger(__name__)


@std_main(log=log, debug=True)
def main(argv=None, **kwargs):
    """Process command line arguments."""
    return vce.cli.main(argv, **kwargs)


if __name__ == "__main__":
    main(sys.argv[1:])
