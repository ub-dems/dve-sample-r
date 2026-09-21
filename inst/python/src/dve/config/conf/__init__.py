from abc import abstractmethod

from dve.config.conf.db import DbConfig

import vce.config.conf as vce_conf
import vce.config.conf.base as vce_base
import vce.config.conf.db as vce_conf_db


class AppConfigConsts(object):
    CONFIG_S_DEFAULT = vce_conf.AppConfigConsts.CONFIG_S_DEFAULT

    CFG_TYPE_GENERIC = vce_conf.AppConfigConsts.CFG_TYPE_GENERIC
    CFG_TYPE_YAML = vce_conf.AppConfigConsts.CFG_TYPE_YAML

    DB_S_DEFAULT = vce_conf.AppConfigConsts.DB_S_DEFAULT

    DMY_B_BASE = "test"
    DMY_B_DUMMY_SCRIPT = DMY_B_BASE + "/" + "dummy_script"
    DMY_C_DUMMY_SCRIPT_FILENAME = "filename"


class AppConfig(vce_base.BaseConfig):
    cfg_type = AppConfigConsts.CFG_TYPE_GENERIC

    def __init__(self, name: str):
        self.name = name

    @abstractmethod
    def db(self, db_name: str) -> DbConfig:
        pass

    @abstractmethod
    def data(self) -> dict:
        pass


class AppConfigEx(AppConfig, vce_base.BaseConfigEx):
    @abstractmethod
    def db_config(self, db_name: str) -> dict:
        pass

    @abstractmethod
    def db_inner(self, db_name: str) -> vce_conf_db.DbConfig:
        pass

    @abstractmethod
    def db_config_cache(self) -> dict:
        pass


# ruff: noqa: PLC0415
class AppConfigs(object):
    @staticmethod
    def unload_all():
        from dve.config.conf.app_config import unload_all_configs

        unload_all_configs()

    @staticmethod
    def get(what=AppConfigConsts.CONFIG_S_DEFAULT) -> AppConfig:
        from dve.config.conf.app_config import get_config_store

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
        section: str = vce_conf.AppConfigConsts.CONFIG_L_SECTION_NAME,
    ) -> vce_conf.ProjectConfig:
        result = get_local_config(section)
        return result


def get_local_config(
    section: str = vce_conf.AppConfigConsts.CONFIG_L_SECTION_NAME,
) -> vce_conf.ProjectConfig:
    result = vce_conf.get_local_config(section)
    return result


def get_config(what=AppConfigConsts.CONFIG_S_DEFAULT) -> AppConfig:
    return AppConfigs.get(what)


def db_config(db_name=AppConfigConsts.DB_S_DEFAULT) -> DbConfig:
    return AppConfigs.db(db_name)


def cfg(what=AppConfigConsts.CONFIG_S_DEFAULT) -> AppConfig:
    return get_config(what)


def cdb(db_name=AppConfigConsts.DB_S_DEFAULT) -> DbConfig:
    return db_config(db_name)
