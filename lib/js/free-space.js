"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const child_process_1 = require("child_process");
const utils_1 = require("./utils");
const chalk_1 = require("chalk");
function main() {
    printDisks(loadDisks());
}
var State;
(function (State) {
    State["OK"] = "OK";
    State["GOOD"] = "GOOD";
    State["BAD"] = "BAD";
})(State || (State = {}));
function parseDfLine(line) {
    const parts = line.trim().split(/\s+/);
    const [device, size, used, available, capacity] = parts;
    const mount = parts[parts.length - 1];
    if (device === 'Filesystem')
        return;
    if (mount !== '/' && !/\/(Volumes|media)/.test(mount))
        return;
    return {
        device,
        size: Number(size),
        used,
        available: Number(available),
        capacity,
        availableGB: sizeToGB(available),
        sizeGB: sizeToGB(size),
        mount,
        state: calculateState(capacity)
    };
}
function sizeToGB(value) {
    return (parseFloat(value) / 1024 / 1024).toFixed(1);
}
function calculateState(capacity) {
    const c = parseInt(capacity, 10);
    if (c > 90)
        return State.BAD;
    if (c > 70)
        return State.OK;
    return State.GOOD;
}
function loadDisks() {
    return child_process_1.execSync('df')
        .toString()
        .split('\n')
        .map(parseDfLine)
        .filter(utils_1.notUndefined);
}
function printDisks(disks) {
    const columnWidths = calculateColumnWidths(disks);
    disks.forEach(disk => console.info(stringifyDisk(disk, columnWidths)));
}
function stringifyDisk(disk, widths) {
    const { capacity, availableGB, sizeGB, mount, device } = disk;
    let part1 = [
        utils_1.justifyRight(capacity, widths.capacity),
        utils_1.justifyRight(availableGB, widths.availableGB) + 'G',
        'free (of',
        utils_1.justifyRight(sizeGB, widths.sizeGB) + 'G)',
        utils_1.justifyLeft(mount, widths.mount)
    ].join(' ');
    switch (disk.state) {
        case State.GOOD:
            part1 = chalk_1.default.green(part1);
            break;
        case State.OK:
            part1 = chalk_1.default.yellow(part1);
            break;
        case State.BAD:
            part1 = chalk_1.default.red(part1);
            break;
    }
    return [part1, chalk_1.default.grey(`(${device})`)].join(' ');
}
function calculateColumnWidths(disks) {
    const widths = {};
    disks.forEach(disk => {
        Object.keys(disk).forEach(key => {
            const width = widths[key] || 0;
            const value = disk[key].toString();
            widths[key] = Math.max(width, value.length);
        });
    });
    return widths;
}
main();
