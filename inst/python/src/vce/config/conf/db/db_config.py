from typing import Any

from vce.config.conf.db import DbConfig
from vce.config.conf import AppConfigEx
from vce.config.conf.base.base_config import BaseConfigImpl

DB_TYPE_GENERIC = "generic"
DB_TYPE_SQLITE = "sqlite"
DB_TYPE_MYSQL = "mysql"
DB_TYPE_POSTGRESQL = "postgresql"

# ruff: noqa: PLW0108
DB_REG_CLASSES = {
    DB_TYPE_SQLITE: lambda name, config: LtDbConfig.create(name, config),
    DB_TYPE_MYSQL: lambda name, config: MyDbConfig.create(name, config),
    DB_TYPE_POSTGRESQL: lambda name, config: PgDbConfig.create(name, config),
}


class AbsDbConfig(BaseConfigImpl, DbConfig):
    def __init__(self, name: str, config: dict):
        super().__init__(name, config)

    def uri(self) -> str:
        cfg = self.conf
        if "uri" not in cfg:
            raise ValueError(f"alias not found for db source: {self.name}")
        uri = str(cfg["uri"])
        result = uri.format(**cfg)
        return result

    def get_value(self, key: str, default_value: Any = None) -> Any:
        cfg = self.conf
        result = cfg.get(key, default_value)
        return result

    def has_value(self, key: str) -> bool:
        try:
            value = self.get_value(key)
            return value is not None
        except ValueError:
            return False

    def dump(self, full: bool = False) -> str:
        if full:
            result = self.dump_object(self.conf)
            return result
        else:
            uri = self.uri()
            result = self.dump_object_uri(uri)
            return result


class RefDbConfig(AbsDbConfig):
    db_type = DB_TYPE_GENERIC

    def __init__(self, name: str, config: dict, delegate: AbsDbConfig):
        super().__init__(name, config)
        self.delegate = delegate

    @classmethod
    def create(cls, name: str, config: dict, delegate: AbsDbConfig) -> AbsDbConfig:
        result = RefDbConfig(name, config, delegate)
        return result

    def uri(self) -> str:
        return self.delegate.uri()


class LtDbConfig(AbsDbConfig):
    db_type = DB_TYPE_SQLITE

    def __init__(self, name: str, config: dict):
        super().__init__(name, config)

    @classmethod
    def create(cls, name: str, config: dict) -> AbsDbConfig:
        result = MyDbConfig(name, config)
        return result


class MyDbConfig(AbsDbConfig):
    db_type = DB_TYPE_MYSQL

    def __init__(self, name: str, config: dict):
        super().__init__(name, config)

    @classmethod
    def create(cls, name: str, config: dict) -> AbsDbConfig:
        result = MyDbConfig(name, config)
        return result


class PgDbConfig(AbsDbConfig):
    db_type = DB_TYPE_POSTGRESQL

    def __init__(self, name: str, config: dict):
        super().__init__(name, config)

    @classmethod
    def create(cls, name: str, config: dict) -> AbsDbConfig:
        result = PgDbConfig(name, config)
        return result


class DbConfigFactory(object):
    @classmethod
    def get_direct(cls, app_config: AppConfigEx, name: str) -> AbsDbConfig:
        db_config = app_config.db_config(name)
        db_type = str(db_config["type"]).lower()
        db_create = DB_REG_CLASSES[db_type]
        result = db_create(name, db_config)
        return result

    @classmethod
    def get_delegate(cls, app_config: AppConfigEx, name: str) -> AbsDbConfig:
        config = app_config.db_config(name)
        if "alias" not in config:
            raise ValueError(f"alias not found for db source: {name}")
        db_name = config["alias"]
        result = cls.get_direct(app_config, db_name)
        return result

    @classmethod
    def get_instance(cls, app_config: AppConfigEx, name: str) -> AbsDbConfig:
        config = app_config.db_config(name)
        if "alias" in config:
            delegate = cls.get_delegate(app_config, name)
            result = RefDbConfig.create(name, config, delegate)
        else:
            result = cls.get_direct(app_config, name)
        return result
