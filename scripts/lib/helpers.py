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
    file = open(filename, 'wb')
    file.write(body)
    file.close()


def extract(filename: str):
    basename = path.basename(filename)
    dirname = path.dirname(filename)
    extract_command = _extract_command(basename)

    if os.system(f'cd "{dirname}" && {extract_command}') != 0:
        raise Exception(
            f'Error: failed to extract, \
                    command "{extract_command}" return non-zero exit code')


def _extract_command(filename: str) -> str:
    if filename.endswith('.tar.gz'):
        return f'tar xzf {filename}'

    if filename.endswith('.zip'):
        return f'unzip {filename}'

    raise Exception(f"Can't extract {filename}, extension not supported")
