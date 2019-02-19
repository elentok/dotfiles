"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const child_process_1 = require("child_process");
function parseDfLine(line) {
    const column = '([^\\s]+)\\s+';
    const re = new RegExp(`^${column}${column}${column}${column}${column}(.*)$`);
    const match = line.match(re);
    return {
        device: match[1],
        totalKB: parseInt(match[2], 10),
        usedKB: parseInt(match[3], 10),
        freeKB: parseInt(match[4], 10),
        freeGB: parseInt(match[4], 10) / 1024 / 1024,
        capacity: parseInt(match[5], 10) / 100,
        mount: match[6]
    };
}
function free() {
    return child_process_1.execSync('df')
        .toString()
        .trim()
        .split('\n')
        .slice(1)
        .map(line => parseDfLine(line));
}
exports.free = free;
function formatGB(gb) {
    return `${gb.toFixed(1)}GB`;
}
exports.formatGB = formatGB;
function formatDisk(disk) {
    return `${disk.mount} (${disk.freeGB.toFixed(1)}GB free)`;
}
exports.formatDisk = formatDisk;
