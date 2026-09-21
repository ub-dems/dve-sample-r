import os.path
from typing import Any
from abc import abstractmethod

from vce.config.conf.base import BaseConfig, BaseConfigEx, BaseConfigConsts

from vce.common.util.format import dump_object, dump_object_uri
from vce.common.util.lint import unused


class BaseConfigMixin(BaseConfigEx):
    # BaseConfig interface
    @abstractmethod
    def get_value(self, key: str) -> Any:
        pass

    @abstractmethod
    def has_value(self, key: str) -> bool:
        pass

    @abstractmethod
    def dump(self, full: bool = False) -> str:
        pass

    # BaseConfigEx interface
    @abstractmethod
    def data(self) -> dict:
        pass

    @abstractmethod
    def db_config(self, db_name: str) -> dict:
        pass

    # default implementation

    def dump_object(self, obj: Any) -> str:
        return dump_object(obj)

    def dump_object_uri(self, uri: str) -> str:
        return dump_object_uri(uri)

    def dump_value(self, key: str) -> str:
        try:
            obj = self.get_value(key)
            result = self.dump_object(obj)
            return result
        except ValueError:
            return ""

    def get_int(self, key: str, defValue: int = 0) -> int:
        obj = None
        try:
            obj = self.get_value(key)
        except ValueError:
            return defValue
        result = int(obj)
        return result

    def get_float(self, key: str, defValue: float = 0) -> float:
        obj = None
        try:
            obj = self.get_value(key)
        except ValueError:
            return defValue
        result = float(obj)
        return result

    def get_bool(self, key: str, defValue: bool = False) -> bool:
        obj = None
        try:
            obj = self.get_value(key)
        except ValueError:
            return defValue
        s = str(obj).lower()
        result = s in {"y", "yes", "t", "true", "1"}
        return result

    def get_str(self, key: str, defValue: str = "") -> str:
        obj = None
        try:
            obj = self.get_value(key)
        except ValueError:
            return defValue
        result = str(obj)
        return result


class BaseConfigImpl(BaseConfigMixin):
    def __init__(self, name: str, conf: dict | None = None):
        self.name = name
        self.conf = conf or {}
        self.path_separator = BaseConfigConsts.CONFIG_C_PATH_SEP

    def db_config(self, db_name: str) -> dict:
        result = self.conf["data"]["db"][db_name]
        return result

    def data(self) -> dict:
        return self.conf

    def key_path(self, key: str) -> list:
        result = key.split(self.path_separator)
        return result

    def get_value(self, key: str) -> Any:
        keys = self.key_path(key)
        cfg = self.conf
        ks = []
        for k in keys:
            try:
                ks.append(k)
                cfg = cfg[k]
            except KeyError as ex:
                msg = f"config key not found: {ks} in key: {key}"
                raise ValueError(msg) from ex
        return cfg

    def has_value(self, key: str) -> bool:
        try:
            self.get_value(key)
            return True
        except ValueError:
            return False

    def dump(self, full: bool = False) -> str:
        unused(full)
        result = dump_object(self.conf)
        return result


class BaseConfigWrapper[T: BaseConfigEx](BaseConfigImpl):
    def __init__(self, name: str, inner: T):
        super().__init__(name)
        self.inner = inner

    def db_config(self, db_name: str) -> dict:
        return self.inner.db_config(db_name)

    def data(self) -> dict:
        return self.inner.data()

    def get_value(self, key: str) -> Any:
        return self.inner.get_value(key)

    def has_value(self, key: str) -> bool:
        return self.inner.has_value(key)

    def dump_value(self, key: str) -> str:
        return self.inner.dump_value(key)

    def get_int(self, key: str, defValue: int = 0) -> int:
        return self.inner.get_int(key, defValue)

    def get_bool(self, key: str, defValue: bool = False) -> bool:
        return self.inner.get_bool(key, defValue)

    def get_float(self, key: str, defValue: float = 0.0) -> float:
        return self.inner.get_float(key, defValue)

    def get_str(self, key: str, defValue: str = "") -> str:
        return self.inner.get_str(key, defValue)

    def dump_object(self, obj: Any) -> str:
        return self.inner.dump_object(obj)

    def dump_object_uri(self, uri: str) -> str:
        return self.inner.dump_object_uri(uri)

    def dump(self, full: bool = False) -> str:
        return self.inner.dump(full)


class ErrAbsConfig(BaseConfigImpl, BaseConfigMixin):
    cfg_type = BaseConfigConsts.CFG_TYPE_ERROR

    def __init__(self, name: str, ex: Exception):
        super().__init__(name, {"ex": ex})
        self.ex = ex


class BaseConfigStore[T: BaseConfig]:
    def __init__(self, config_class: type[BaseConfig]):
        self._config_class = config_class
        self._config = {}

    def is_config_defined(self, what=BaseConfigConsts.CONFIG_S_DEFAULT) -> bool:
        return True

    def config_name(self, what=BaseConfigConsts.CONFIG_S_DEFAULT) -> str:
        result = None
        if what == BaseConfigConsts.CONFIG_S_MAIN:
            result = BaseConfigConsts.CONFIG_F_MAIN
        if result is None:
            raise ValueError(f'Config Name unknown: "{what}", cannot load')
        return result

    def config_path(self, what=BaseConfigConsts.CONFIG_S_DEFAULT) -> str:
        name = self.config_name(what)
        fn = os.path.join(BaseConfigConsts.CONFIG_F_ROOT, name)
        result = os.path.normpath(fn)
        return result

    @abstractmethod
    def load_config(self, what=BaseConfigConsts.CONFIG_S_DEFAULT) -> T:
        pass

    def get_config(self, what=BaseConfigConsts.CONFIG_S_DEFAULT) -> T:
        if what in self._config:
            handle = self._config[what]
            result = handle["data"]
            return result

        handle = {"what": what, "loaded": True, "failed": False}
        self._config[what] = handle
        try:
            handle["data"] = self.load_config(what)
            handle["error"] = None

        except Exception as ex:
            handle["failed"] = True
            handle["error"] = ex
            handle["data"] = ErrAbsConfig(what, ex)
            print(type(ex))
            print(ex.args)
            print(ex)
            raise ex

        h = self._config[what]
        result = h["data"]

        if result is None:
            ex = h["error"]
            raise ValueError(f"Config Name {what} not loaded: {type(ex)} {ex.args}")

        return result
