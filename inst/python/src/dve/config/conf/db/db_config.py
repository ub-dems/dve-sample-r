from dve.config.conf.db import DbConfig
from dve.config.conf import AppConfigEx

import vce.config.conf.base.base_config as vce_base
import vce.config.conf.db as vce_conf_db


class DbConfigBase(vce_base.BaseConfigWrapper[vce_conf_db.DbConfigEx]):
    def __init__(self, name: str, inner: vce_conf_db.DbConfigEx):
        super().__init__(name, inner)


class DbConfigImpl(DbConfigBase, DbConfig):
    def __init__(self, name: str, inner: vce_conf_db.DbConfigEx):
        super().__init__(name, inner)

    def uri(self) -> str:
        return self.inner.uri()

    def dump(self, full: bool = False) -> str:
        return self.inner.dump(full)

    @classmethod
    def create(cls, name: str, inner: vce_conf_db.DbConfig) -> DbConfig:
        inner_ex = inner.as_ex()
        result = DbConfigImpl(name, inner_ex)
        return result


class DbConfigFactory(object):
    @classmethod
    def get_instance(cls, app_config: AppConfigEx, name: str) -> DbConfig:
        db_config_cache = app_config.db_config_cache()
        if name in db_config_cache:
            return db_config_cache[name]
        else:
            inner = app_config.db_inner(name)
            db_config = DbConfigImpl.create(name, inner)
            db_config_cache[name] = inner
            return db_config
