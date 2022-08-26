#!/usr/bin/env python3

from typing import List, Optional
from enum import Enum
from dataclasses import dataclass
import subprocess
import re
from rich.table import Table
from rich.console import Console

RELEVANT_MOUNT_POINT_RE = re.compile("/($|Volumes|media|usr|mnt)")
SPACES_RE = re.compile("\\s+")


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

    def style(self) -> str:
        state = self.state()
        if state == State.BAD:
            return "red"
        elif state == State.OK:
            return "orange"
        return "green"


def main():
    render_disks(load_disks())


def render_disks(disks: List[Disk]):
    table = Table(title="Free Space", border_style="#666666")
    table.add_column("Mount")
    table.add_column("Usage", justify="right")
    table.add_column("Free (GB)", justify="right")
    table.add_column("Size (GB)", justify="right")
    table.add_column("Device")

    for disk in disks:
        table.add_row(
            disk.mount,
            f"{disk.used_percentage}%",
            disk.available_gb(),
            disk.size_gb(),
            disk.device,
            style=disk.style(),
        )

    console = Console()
    console.print(table)


def load_disks() -> List[Disk]:
    lines = subprocess.check_output(["df"]).decode("utf-8").splitlines()[1:]
    disks = map(parse_df_line, lines)
    disks = [
        disk
        for disk in disks
        if disk is not None and RELEVANT_MOUNT_POINT_RE.match(disk.mount)
    ]
    return disks


def parse_df_line(line: str) -> Optional[Disk]:
    *device, size, used, available, used_percentage, mount = SPACES_RE.split(
        line.strip()
    )
    return Disk(
        device=" ".join(device),
        used=used,
        used_percentage=int(used_percentage[:-1]),
        size=int(size),
        available=int(available),
        mount=mount,
    )


def size_to_gb(value: int) -> str:
    return "%.1f G" % (value / 1024 / 1024)


if __name__ == "__main__":
    main()
