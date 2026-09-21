import logging
import os
import sys
import unittest

from vce.config.data import cfd
from vce.common.util.lint import unused

logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

log = logging.getLogger(__name__)

CHECK_EXISTING = False


class ConfigDataTest(unittest.TestCase):
    warnings_no = 0

    # noinspection PyUnusedLocal
    def verify_dir(self, name, path, exists, isdir):
        unused(name, path)
        if not (exists and isdir):
            self.warnings_no = self.warnings_no + 1
        return not CHECK_EXISTING or (exists and isdir)

    def log_dir(self, name, path):
        exists = os.path.exists(path)
        isdir = os.path.isdir(path)

        mess = "+++ {}: {} -> {}".format(name, path, os.path.realpath(path))

        if exists and isdir:
            log.debug(mess)
        else:
            log.warning("%s %s", mess, "!NOTFND")
        return self.verify_dir(name, path, exists, isdir)

    def test_default_data_home_defined(self):
        log.debug("+++ DATA_HOME: %s", cfd().DATA_HOME)
        assert cfd().DATA_HOME is not None

    def test_default_data_home(self):
        assert self.log_dir("DATA_HOME", cfd().DATA_HOME)

    def test_default_data_work_defined(self):
        log.debug("+++ DATA_WORK: %s", cfd().DATA_WORK)
        assert cfd().DATA_WORK is not None

    def test_default_data_work(self):
        assert self.log_dir("DATA_WORK", cfd().DATA_WORK)

    def test_default_data_logs_defined(self):
        log.debug("+++ DATA_LOGS: %s", cfd().DATA_LOGS)
        assert cfd().DATA_LOGS is not None

    def test_default_data_logs(self):
        assert self.log_dir("DATA_LOGS", cfd().DATA_LOGS)

    def test_default_data_host_defined(self):
        log.debug("+++ DATA_HOST: %s", cfd().DATA_HOST)
        assert cfd().DATA_HOST is not None

    def test_default_data_host(self):
        assert self.log_dir("DATA_HOST", cfd().DATA_HOST)

    def test_default_data_user_defined(self):
        log.debug("+++ DATA_USER: %s", cfd().DATA_USER)
        assert cfd().DATA_USER is not None

    def test_default_data_user(self):
        assert self.log_dir("DATA_USER", cfd().DATA_USER)

    def test_default_data_desk_defined(self):
        log.debug("+++ DATA_DESK: %s", cfd().DATA_DESK)
        assert cfd().DATA_DESK is not None

    def test_default_data_desk(self):
        assert self.log_dir("DATA_DESK", cfd().DATA_DESK)

    def test_default_data_test_defined(self):
        log.debug("+++ DATA_TEST: %s", cfd().DATA_TEST)
        assert cfd().DATA_TEST is not None

    def test_default_data_test(self):
        assert self.log_dir("DATA_TEST", cfd().DATA_TEST)

    def test_default_data_temp_defined(self):
        log.debug("+++ DATA_TEMP: %s", cfd().DATA_TEMP)
        assert cfd().DATA_TEMP is not None

    def test_default_data_temp(self):
        assert self.log_dir("DATA_TEMP", cfd().DATA_TEMP)

    def test_config_loader(self):
        o = cfd()
        assert o is not None
        log.debug("+++ cfd:  %s", str(o))

    def setUp(self):
        # self.conf_dir = os.environ['CONFIG_DIR']
        pass

    def tearDown(self):
        pass


if __name__ == "__main__":
    unittest.main()
