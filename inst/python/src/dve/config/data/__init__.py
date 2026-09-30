from dataclasses import dataclass

import vce.config.data as vcd


def conf_dir(env_key, default_value):
    return vcd.conf_dir(env_key, default_value)


@dataclass
class DataConfig(vcd.DataConfig):
    DATA_CUST = conf_dir("PC_DATA_CUST", "./data/ext/cust")

    # DATA_WORK = conf_dir("PC_DATA_HOME", "./.")

    # DATA_LOGS = conf_dir("PC_DATA_HOME", "./logs")

    # DATA_TEMP = conf_dir("PC_DATA_HOME", "./data/tmp")
    # DATA_TEST = conf_dir("PC_DATA_HOME", "./data/int/test")

    # DATA_HOME = conf_dir("PC_DATA_HOME", "./data/ext/home")
    # DATA_HOST = conf_dir("PC_DATA_HOST", "./data/ext/host")
    # DATA_USER = conf_dir("PC_DATA_USER", "./data/ext/user")

    # DATA_DNET = conf_dir("PC_DATA_DNET", "./data/ext/dnet")

    # DATA_DESK = conf_dir("PC_DATA_DESK", "~/Desktop")


_cfd = DataConfig()


def cfd() -> DataConfig:
    return _cfd
