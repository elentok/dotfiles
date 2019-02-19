import { IDisk, free, formatGB } from './disks'

const MIN_FREE_GB = 400

function checkFreeSpace() {
  return free()
    .filter(disk => shouldWarn(disk))
    .map(disk => `Disk "${disk.mount}" has low free space (only ${formatGB(disk.freeGB)})`)
}

function shouldWarn(disk: IDisk) {
  return disk.freeGB < MIN_FREE_GB && (disk.mount === '/' || disk.mount.match(/^\/(media|Volumes)/))
}

const warnings = checkFreeSpace()

if (warnings.length > 0) {
  warnings.forEach(warning => {
    console.info(warning)
  })
}
