import { IDisk, free, formatGB } from "./disks";

const MIN_FREE_GB = 4;

function shouldWarn(disk: IDisk): boolean {
  return (
    disk.freeGB < MIN_FREE_GB &&
    (disk.mount === "/" || disk.mount.match(/^\/(media|Volumes)/) != null)
  );
}

function checkFreeSpace(): string[] {
  return free()
    .filter((disk) => shouldWarn(disk))
    .map((disk) => `Disk "${disk.mount}" has low free space (only ${formatGB(disk.freeGB)})`);
}

const warnings = checkFreeSpace();

if (warnings.length > 0) {
  warnings.forEach((warning) => {
    console.info(warning);
  });
}
