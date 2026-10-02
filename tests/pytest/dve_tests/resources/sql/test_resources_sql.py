import logging
import sys
import unittest

from dve.resources import sql

logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

log = logging.getLogger(__name__)


class ResourcesSqlTest(unittest.TestCase):
    warnings_no = 0

    def test_load_sql_resource(self):
        log.debug("+++ sql.text('demo-clock.sql'), ...")
        text = sql.text("demo-clock.sql")
        log.debug("+++ sql.text('demo-clock.sql'), done.\n %s", text)
        assert text is not None

    def setUp(self):
        # self.conf_dir = os.environ['CONFIG_DIR']
        pass

    def tearDown(self):
        pass


if __name__ == "__main__":
    unittest.main()
