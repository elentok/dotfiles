#!/usr/bin/env python3

import argparse


def main():
    parser = argparse.ArgumentParser(description="Optimizes images")
    parser.add_argument(
        "-v", "--verbose", action="store_true", help="Show more information"
    )
    parser.add_argument(
        "-b", "--bw", action="store_true", help="Use 2 colors and a depth of 1"
    )
    parser.add_argument(
        "-g", "--grayscale", action="store_true", help="Use 16 colors and a depth of 4"
    )
    parser.add_argument("-c", "--colors", action="store_true", help="Number of colors")
    parser.add_argument("-d", "--depth", action="store_true", help="Depth of color")
    parser.add_argument(
        "-f",
        "--fit",
        nargs=1,
        help="Resize the image to fit in these bounds (if no size defined defaults to 1500x1500)",
    )
    parser.add_argument(
        "-o", "--output", help='Output directory (defaults to "optimized")'
    )
    parser.add_argument(
        "-s", "--silent", action="store_true", help="Don't overwrite files"
    )

    args = parser.parse_args()
    print(args)


if __name__ == "__main__":
    main()
