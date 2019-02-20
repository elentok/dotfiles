"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const disks_1 = require("./disks");
const MIN_FREE_GB = 4;
function checkFreeSpace() {
    return disks_1.free()
        .filter(disk => shouldWarn(disk))
        .map(disk => `Disk "${disk.mount}" has low free space (only ${disks_1.formatGB(disk.freeGB)})`);
}
function shouldWarn(disk) {
    return disk.freeGB < MIN_FREE_GB && (disk.mount === '/' || disk.mount.match(/^\/(media|Volumes)/));
}
const warnings = checkFreeSpace();
if (warnings.length > 0) {
    warnings.forEach(warning => {
        console.info(warning);
    });
}
