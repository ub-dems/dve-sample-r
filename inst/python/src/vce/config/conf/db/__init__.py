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


class DbConfigEx(DbConfig, BaseConfigEx):
    @abstractmethod
    def uri(self) -> str:
        pass

    @abstractmethod
    def dump(self, full: bool = False) -> str:
        pass


class DbConfigs(object):
    pass
