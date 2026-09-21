import re
from abc import abstractmethod
from typing import cast
from vce.config.conf.base import BaseConfig, BaseConfigEx


class DbConfigConsts(object):
    DB_TYPE_GENERIC = "generic"


class DbConfig(BaseConfig):
    db_type = DbConfigConsts.DB_TYPE_GENERIC

    @abstractmethod
    def uri(self) -> str:
        pass

    @abstractmethod
    def dump(self, full: bool = False) -> str:
        pass

    def as_ex(self) -> "DbConfigEx":
        result = cast("DbConfigEx", self)
        return result

    @staticmethod
    def dump_object_uri(uri: str) -> str:
        result = re.sub("://([^:]*):([^@]*)@", r"://\1:***@", uri)
        return result


class DbConfigEx(DbConfig, BaseConfigEx):
    @abstractmethod
    def data(self) -> dict:
        pass

    @abstractmethod
    def db_config(self, db_name: str) -> dict:
        pass


class DbConfigs(object):
    pass
