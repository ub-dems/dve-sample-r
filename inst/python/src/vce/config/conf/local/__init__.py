from pathlib import Path
from typing import Any
from abc import abstractmethod

from vce.config.conf.base import BaseConfig


class LocalConfigConsts(object):
    CONFIG_L_PROJECT_FILE = "pyproject.toml"
    CONFIG_L_SECTION_PARENT = "tool"
    CONFIG_L_SECTION_NAME = "local"
    CONFIG_L_ENV_PREFIX = "X_RUN_"
    CONFIG_L_KEY_CONFIG = "config"
    CONFIG_L_DEF_CONFIG = "config.yaml"
    CONFIG_L_KEY_HAS_CONFIG = "has_config"
    CONFIG_L_DEF_HAS_CONFIG = True


class ProjectConfig(BaseConfig):
    @property
    @abstractmethod
    def section(self) -> str:
        pass

    @property
    @abstractmethod
    def base_path(self) -> Path:
        pass

    @property
    @abstractmethod
    def project_path(self) -> Path:
        pass

    @property
    @abstractmethod
    def config_path(self) -> Path:
        pass

    @property
    @abstractmethod
    def has_project(self) -> bool:
        pass

    @property
    @abstractmethod
    def has_config(self) -> bool:
        pass

    @property
    @abstractmethod
    def is_config_defined(self) -> bool:
        pass

    @property
    @abstractmethod
    def local(self) -> dict[str, Any]:
        pass


def get_local_config(section: str = LocalConfigConsts.CONFIG_L_SECTION_NAME) -> ProjectConfig:
    # ruff: noqa: PLC0415
    from vce.config.conf.local.local_config import ProjectConfigStoreGlobals

    result = ProjectConfigStoreGlobals.store.get_local(section)
    return result


#  LocalWords:  PLC, noqa
