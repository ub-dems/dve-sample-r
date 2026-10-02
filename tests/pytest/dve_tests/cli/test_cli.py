import logging
import sys
import pytest
import unittest

from dve.cli import main

logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

log = logging.getLogger(__name__)


class CliTest(unittest.TestCase):
    warnings_no = 0

    @pytest.fixture(autouse=True)
    def _pass_fixtures(self, capsys):
        self.capsys = capsys

    def test_runner_args(self):
        argv = ["-v", "--exec", "main", "--cmd", "test"]
        log.debug("+++ cli.main: %s", str(argv))
        RC = main(argv)
        log.debug("+++ cli.main: %s -> (rc = %d)", str(argv), RC)
        assert RC == 0

    def test_auto_check(self):
        argv = ["--name", "test-01"]
        log.debug("+++ cli.main: %s", str(argv))
        RC = main(argv)
        log.debug("+++ cli.main: %s -> (rc = %d)", str(argv), RC)
        assert RC == 0

    def test_runner_check(self):
        argv = ["-v", "--exec", "main", "--cmd", "auto", "--name", "test-01"]
        log.debug("+++ cli.main: %s", str(argv))
        RC = main(argv)
        log.debug("+++ cli.main: %s -> (rc = %d)", str(argv), RC)
        assert RC == 0

    def setUp(self):
        # self.conf_dir = os.environ['CONFIG_DIR']
        logging.getLogger(__name__)

    def tearDown(self):
        pass


if __name__ == "__main__":
    unittest.main()
