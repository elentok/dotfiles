#!/usr/bin/env python3

from typing import List, Optional
from enum import Enum
from dataclasses import dataclass
import subprocess
import re
from rich.table import Table
from rich.console import Console


class State(Enum):
    OK = "OK"
    GOOD = "GOOD"
    BAD = "BAD"


@dataclass
class Disk:
    device: str
    used: str
    used_percentage: int
    size: int
    available: int
    mount: str

    def size_gb(self) -> str:
        return size_to_gb(self.size)

    def available_gb(self) -> str:
        return size_to_gb(self.available)

    def state(self) -> State:
        if self.used_percentage > 90:
            return State.BAD
        elif self.used_percentage > 70:
            return State.OK
        return State.GOOD


def main():
    disks = load_disks()
    table = Table(title="Free Space")
    table.add_column("Usage", justify="right")
    table.add_column("Free (GB)", justify="right")
    table.add_column("Size (GB)", justify="right")
    table.add_column("Mount")
    table.add_column("Device")

    for disk in disks:
        table.add_row(
            f"{disk.used_percentage}%",
            disk.available_gb(),
            disk.size_gb(),
            disk.mount,
            disk.device,
        )

    console = Console()
    console.print(table)
    # print(load_disks())


def load_disks() -> List[Disk]:
    lines = subprocess.check_output(["df"]).decode("utf-8").splitlines()[1:]
    disks = map(parse_df_line, lines)
    disks = [disk for disk in disks if disk is not None]
    return disks


def parse_df_line(line: str) -> Optional[Disk]:
    print(re.compile("\\s+").split(line.strip()))
    device, size, used, available, used_percentage, mount = re.compile("\s+").split(
        line.strip()
    )
    return Disk(
        device=device,
        used=used,
        used_percentage=int(used_percentage[:-1]),
        size=int(size),
        available=int(available),
        mount=mount,
        state=State.OK,
    )


def size_to_gb(value: int) -> str:
    return "%.1f" % (value / 1024 / 1024)


# return execSync("df").toString().split("\n").map(parseDfLine).filter(notUndefined);


if __name__ == "__main__":
    main()
