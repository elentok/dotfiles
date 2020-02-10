import os
from os import path

import requests


def download(url: str, filename: str):
    dirname = path.dirname(filename)
    if not path.exists(dirname):
        os.system('mkdir -p "%s"' % dirname)
        #  os.mkdir(dirname)
    body = requests.get(url).content
    file = open(filename, 'wb')
    file.write(body)
    file.close()
