import logging
import sys
import re
import unittest

from vce.config import conf

logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

log = logging.getLogger(__name__)


class ConfigDbTest(unittest.TestCase):
    warnings_no = 0

    def test_config_demo(self):
        actual_db_config = conf.get_config().db("demo")
        assert actual_db_config is not None
        actual_config = actual_db_config.as_ex().data()
        assert actual_config is not None
        actual_uri = actual_db_config.uri()
        assert re.search("://", actual_uri)
        log.debug("+++ CONFIG MODEL (demo): %s", actual_db_config.dump(True))
        log.debug("+++ CONFIG URI   (demo): %s", actual_db_config.dump())

    def test_config_demo_lt(self):
        actual_db_config = conf.get_config().db("demo_lt")
        assert actual_db_config is not None
        actual_uri = actual_db_config.uri()
        assert re.search("://", actual_uri)
        assert re.search("^sqlite", actual_uri)
        log.debug("+++ CONFIG MODEL (demo_my): %s", actual_db_config.dump(True))
        log.debug("+++ CONFIG URI   (demo_my): %s", actual_db_config.dump())

    def test_config_demo_my(self):
        actual_db_config = conf.get_config().db("demo_my")
        assert actual_db_config is not None
        actual_config = actual_db_config.as_ex().data()
        assert actual_config is not None
        actual_uri = actual_db_config.uri()
        assert re.search("://", actual_uri)
        assert re.search("^mysql", actual_uri)
        log.debug("+++ CONFIG MODEL (demo_my): %s", actual_db_config.dump(True))
        log.debug("+++ CONFIG URI   (demo_my): %s", actual_db_config.dump())

    def test_config_demo_pg(self):
        actual_db_config = conf.get_config().db("demo_pg")
        assert actual_db_config is not None
        actual_config = actual_db_config.as_ex().data()
        assert actual_config is not None
        actual_uri = actual_db_config.uri()
        assert re.search("://", actual_uri)
        assert re.search("^postgresql", actual_uri)
        log.debug("+++ CONFIG MODEL (demo_pg): %s", actual_db_config.dump(True))
        log.debug("+++ CONFIG URI   (demo_pg): %s", actual_db_config.dump())

    def setUp(self):
        pass

    def tearDown(self):
        pass


if __name__ == "__main__":
    unittest.main()
