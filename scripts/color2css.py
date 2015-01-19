#!/usr/bin/env python

import subprocess
import re

import argparse

HELP = """
Convert colors to css using the name-that-color npm package:
https://www.npmjs.com/package/name-that-color
"""

def main():
    parser = argparse.ArgumentParser(description=HELP)
    parser.add_argument('colors',
                        metavar='COLOR',
                        nargs='+',
                        help='colors to convert to css')
    parser.add_argument('-f', '--format',
                        default='sass',
                        choices=['sass', 'less'],
                        nargs='?',
                        help='variable format')
    parser.add_argument('-t', '--test',
                        help='run tests')

    args = parser.parse_args()
    if args.test:
        import doctest
        doctest.testmod()
        return

    for color in args.colors:
        convert(color, args.format)

def convert(color, var_format):
    prefix = __find_prefix(var_format)
    color = normalize_color(color)
    name = find_name(color)
    print "%s%s: %s;" % (prefix, name, color)

def find_name(color):
    output = subprocess.check_output(["name-that-color", color]).strip()
    return __find_name_in_output(output)

def __find_prefix(var_format):
    if var_format == "less":
        return "@"
    else:
        return "$"

def __find_name_in_output(output):
    name = re.sub("^.* name is ", "", output)
    name = name.lower().replace(" ", "-")
    return name

def normalize_color(color):
    """
    >>> normalize_color("abab09")
    '#abab09'
    >>> normalize_color("ccc")
    '#ccc'
    """
    if re.match("^[A-Fa-f0-9]{3,6}$", color):
        color = "#" + color

    return color

if __name__ == "__main__":
    main()

