from abc import abstractmethod
from typing import cast

from vce.config.conf.base import BaseConfig, BaseConfigEx
from vce.config.conf.local import ProjectConfig, get_local_config
from vce.config.conf.db import DbConfig


class AppConfigConsts(object):
    CONFIG_S_DEFAULT = "main"
    CONFIG_L_SECTION_NAME = "local"

    CFG_TYPE_GENERIC = "generic"
    CFG_TYPE_YAML = "yaml"

    DB_S_DEFAULT = "data"


class AppConfig(BaseConfig):
    cfg_type = AppConfigConsts.CFG_TYPE_GENERIC

    def __init__(self, name: str):
        self.name = name

    @abstractmethod
    def db(self, db_name: str) -> DbConfig:
        pass

    def as_ex(self) -> "AppConfigEx":
        result = cast("AppConfigEx", self)
        return result


class AppConfigEx(AppConfig, BaseConfigEx):
    @abstractmethod
    def data(self) -> dict:
        pass

    @abstractmethod
    def db_config(self, db_name: str) -> dict:
        pass


class AppConfigs(object):
    @staticmethod
    def unload_all():
        # ruff: noqa: PLC0415
        from vce.config.conf.app_config import unload_all_configs

        unload_all_configs()

    @staticmethod
    def get(what=AppConfigConsts.CONFIG_S_DEFAULT) -> AppConfig:
        from vce.config.conf.app_config import get_config_store

        store = get_config_store()
        result = store.get_config(what)
        return result

    @staticmethod
    def db(db_name=AppConfigConsts.DB_S_DEFAULT) -> DbConfig:
        app_config = AppConfigs.get()
        result = app_config.db(db_name)
        return result

    @staticmethod
    def local(
        section: str = AppConfigConsts.CONFIG_L_SECTION_NAME,
    ) -> ProjectConfig:
        result = get_local_config(section)
        return result


def get_config(what=AppConfigConsts.CONFIG_S_DEFAULT) -> AppConfig:
    return AppConfigs.get(what)


def db_config(db_name=AppConfigConsts.DB_S_DEFAULT) -> DbConfig:
    return AppConfigs.db(db_name)


#  LocalWords:  toml
