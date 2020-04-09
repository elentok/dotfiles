#!/usr/bin/env python3

import argparse
import re
from typing import List
from os import path


def main():
    parser = argparse.ArgumentParser(prog='rename')
    parser.add_argument('pattern')
    parser.add_argument('replacement')
    parser.add_argument('files', nargs='+')
    parser.add_argument(
        '-y', '--yes', help="Don't ask for confirmation", action='store_true')
    args = parser.parse_args()
    renameables = find_renameables(args.pattern, args.replacement, args.files)
    for renameable in renameables:
        renameable.print()


class Renameable:
    from_fullpath: str
    from_dirname: str
    from_basename: str
    to_fullpath: str
    to_basename: str

    def __init__(self, from_fullpath: str, to_basename: str):
        self.from_fullpath = from_fullpath
        self.to_basename = to_basename
        self.from_dirname = path.dirname(from_fullpath)
        self.from_basename = path.basename(from_fullpath)
        self.to_fullpath = path.join(self.from_dirname, to_basename)

    def print(self, prefix=''):
        print(f'{prefix}{self.from_dirname}/{self.from_basename}')
        print(f'{self.indent(prefix)} => {self.to_basename}')
        #  console.info(`${prefix}${chalk.gray(this.fromDirname)} /${this.fromBasename}`)
        #  console.info(`${this.indent(prefix)} => ${chalk.blue(this.toBasename)}`)

    def indent(self, prefix: str) -> str:
        text = ''
        indent_width = max(len(prefix) + len(self.from_dirname) - 3, 0)
        while len(text) < indent_width:
            text += ' '
        return text


def find_renameables(pattern: str, replacement: str, files: List[str]) -> List[Renameable]:
    regex = re.compile(pattern, re.I)
    matches: List[Renameable] = []
    for filename in files:
        basename = path.basename(filename)
        new_basename = regex.sub(replacement, basename)

        if basename != new_basename:
            matches.append(Renameable(filename, new_basename))

    return matches


if __name__ == '__main__':
    main()
