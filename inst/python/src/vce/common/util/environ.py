# coding: utf-8
import contextlib
import os
from typing import Any, Optional


def env_get(name: str) -> Optional[str]:
    return os.getenv(name)


def env_str(name: str, value: str) -> str:
    return os.getenv(name, value)


def env_val(name: str, value: Any) -> Any:
    val = env_get(name)
    return val if val is not None else value


def env_int(name: str, value: int) -> int:
    val = env_get(name)
    return int(val) if val is not None else value


def env_float(name: str, value: float) -> float:
    val = env_get(name)
    return float(val) if val is not None else value


def env_bool(name: str, value: bool = False) -> bool:
    val = env_get(name)
    trues = {"True", "true", "yes", "y", "1"}
    return val in trues if val is not None else value


@contextlib.contextmanager
def modified_environ(*remove, **update):
    """
    Temporarily updates the ``os.environ`` dictionary in-place.

    The ``os.environ`` dictionary is updated in-place so that the modification
    is sure to work in all situations.

    Taken from:
    * https://github.com/laurent-laporte-pro/stackoverflow-q2059482/blob/master/demo/environ_ctx.py

    @see: https://stackoverflow.com/questions/2059482/temporarily-modify-the-current-processs-environment

    :param remove: Environment variables to remove.
    :param update: Dictionary of environment variables and values to add/update.
    """
    env = os.environ
    update = update or {}
    remove = remove or []

    # List of environment variables being updated or removed.
    stomped = (set(update.keys()) | set(remove)) & set(env.keys())
    # Environment variables and values to restore on exit.
    update_after = {k: env[k] for k in stomped}
    # Environment variables and values to remove on exit.
    remove_after = frozenset(k for k in update if k not in env)

    try:
        env.update(update)
        [env.pop(k, None) for k in remove]
        yield
    finally:
        env.update(update_after)
        [env.pop(k) for k in remove_after]
