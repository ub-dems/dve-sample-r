import importlib.resources
from typing import Optional


def text(name: str, encoding: Optional[str] = None) -> str:
    text = importlib.resources.files(__package__).joinpath(name).read_text(encoding=encoding)
    return text
