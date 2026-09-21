import os
import os.path
import sys
from pathlib import Path
from tempfile import NamedTemporaryFile

import vce.common.util.time as tm

from vce.config.data import cfd


def ensure_dir(dir_name):
    os.makedirs(dir_name, mode=0o775, exist_ok=True)
    return dir_name


def ensure_path(filename):
    dir_name = os.path.dirname(filename)
    ensure_dir(dir_name)
    return filename


def replace_ext(path, ext):
    name, _ = os.path.splitext(path)
    return name + ext


def find_file_upwards(filename: str, start_dir: Path | None = None) -> Path | None:
    d = Path.cwd()
    if start_dir is not None:
        d = start_dir

    root = Path(d.root)

    while d != root:
        attempt = d / filename
        if attempt.exists():
            return attempt
        d = d.parent

    return None


def program_name():
    program_path = sys.argv[0] if bool(sys.argv) else "_"
    program_name, _ = os.path.splitext(os.path.basename(program_path))
    return program_name


def temp_script_dir(dir=None):
    if dir is not None:
        return ensure_dir(dir)
    dd_temp = cfd().DATA_TEMP
    ts = tm.iso_timestamp()
    jn = program_name()
    dd_scripts = f"{dd_temp}/runner/{ts}/{jn}"
    return ensure_dir(dd_scripts)


def write_script(script_body, dir=None):
    dd_scripts = temp_script_dir(dir=dir)
    script_file = NamedTemporaryFile(dir=dd_scripts, suffix=".sh", delete=False)
    with open(script_file.name, "w") as f:
        f.write(script_body)
    os.chmod(script_file.name, 0o775)
    script_file.file.close()
    return script_file.name
