#!/usr/bin/env python3

import argparse
import os
import shlex
import sys


def main():
    for file in sys.argv[1:]:
        convert(file)


def convert(input_filename):
    output_filename = f"{input_filename}.123-x265.mkv"
    print(f"Converting {input_filename}")
    args = [
        "-hide_banner",
        "-i",
        shlex.quote(input_filename),
        "-codec:v",
        "libx265",
        "-crf",
        "26",
        "-preset",
        "medium",
        "-pix_fmt",
        "yuv420p10le",
        "-x265-params",
        "bframes=8:psy-rd=1:aq-mode=3:aq-strength=0.8:deblock=1,1",
        "-codec:a",
        "copy",
        "-codec:s",
        "copy",
        "-n",
    ]
    args.extend(["-vf", "scale=1920:1080"])
    command = " ".join(
        [
            "ffmpeg",
            *args,
            shlex.quote(output_filename),
        ]
    )

    print("============================================================")
    print(command)
    print("============================================================")

    if os.system(command) != 0:
        sys.exit(f"Conversion of {input_filename} failed.")


if __name__ == "__main__":
    main()
