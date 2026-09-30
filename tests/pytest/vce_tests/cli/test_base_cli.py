import logging
import sys
import pytest
import unittest

from vce.cli import main
from vce.config import conf
from vce.common.util import environ

logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

log = logging.getLogger(__name__)


class BaseCliTest(unittest.TestCase):
    warnings_no = 0

    @pytest.fixture(autouse=True)
    def _pass_fixtures(self, capsys):
        self.capsys = capsys

    def test_runner_args(self):
        argv = ["-v", "--exec", "demo", "--cmd", "test"]
        log.debug("+++ cli.main: %s", str(argv))
        RC = main(argv)
        log.debug("+++ cli.main: %s -> (rc = %d)", str(argv), RC)
        assert RC == 0

    def test_auto_default(self):
        argv = []
        log.debug("+++ cli.main: %s", str(argv))
        RC = main(argv)
        log.debug("+++ cli.main: %s -> (rc = %d)", str(argv), RC)
        assert RC == 0

    def test_auto_environ(self):
        with environ.modified_environ(
            X_E_AUTO="test-01",
        ):
            argv = []
            log.debug("+++ cli.main: %s", str(argv))
            RC = main(argv)
            log.debug("+++ cli.main: %s -> (rc = %d)", str(argv), RC)
            assert RC == 0

    def test_auto_script(self):
        argv = ["--name", "test-02"]
        log.debug("+++ cli.main: %s", str(argv))
        RC = main(argv)
        log.debug("+++ cli.main: %s -> (rc = %d)", str(argv), RC)
        assert RC == 0

    def x_test_auto_spawn(self):
        argv = ["--name", "demo-01"]
        log.debug("+++ cli.main: %s", str(argv))
        RC = main(argv)
        log.debug("+++ cli.main: %s -> (rc = %d)", str(argv), RC)
        assert RC == 0

    def setUp(self):
        conf.AppConfigs.unload_all()

    def tearDown(self):
        conf.AppConfigs.unload_all()


if __name__ == "__main__":
    unittest.main()
