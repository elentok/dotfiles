import os
from os import path

import requests


def mkdirp(dirname: str):
    if not path.exists(dirname):
        os.system('mkdir -p "%s"' % dirname)


def download(url: str, filename: str):
    dirname = path.dirname(filename)
    mkdirp(dirname)
    body = requests.get(url).content
    file = open(filename, "wb")
    file.write(body)
    file.close()


def extract(filename: str, strip_components: int = 0):
    basename = path.basename(filename)
    dirname = path.dirname(filename)
    extract_command = _extract_command(basename, strip_components)

    if os.system(f'cd "{dirname}" && {extract_command}') != 0:
        raise Exception(
            f'Error: failed to extract, \
                    command "{extract_command}" return non-zero exit code'
        )


def _extract_command(filename: str, strip_components: int) -> str:
    if filename.endswith(".tar.gz") or filename.endswith(".tgz"):
        return f"tar --strip-components {strip_components} -xzf {filename}"

    if filename.endswith(".zip"):
        # "-o" - overwrites file without confirmation
        return f"unzip -o {filename}"

    raise Exception(f"Can't extract {filename}, extension not supported")
