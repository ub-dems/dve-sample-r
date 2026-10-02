import re
import json
from typing import Any


def dump_object(obj: Any) -> str:
    msg = json.dumps(obj, indent=4, sort_keys=False, default=str)
    result = re.sub('"password": *"[^"]*",', '"password": "***"', msg)
    return result


def dump_object_uri(uri: str) -> str:
    result = re.sub("://([^:]*):([^@]*)@", r"://\1:***@", uri)
    return result
