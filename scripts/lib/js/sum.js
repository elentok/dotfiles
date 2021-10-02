"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sum = void 0;
const fs_1 = require("fs");
const vm_1 = require("vm");
const context = vm_1.createContext();
function lineValue(line) {
    if (/^\s*$/.test(line))
        return 0;
    const valueString = line.split(' ')[0];
    return vm_1.runInContext(valueString, context);
}
function sum(lines) {
    return lines.reduce((sum, line) => sum + lineValue(line), 0);
}
exports.sum = sum;
const input = fs_1.readFileSync(0, 'utf-8')
    .trim()
    .toString();
const totalSum = sum(input.split('\n')).toFixed(3);
console.info(`${input}

= ${totalSum}`);
//# sourceMappingURL=sum.js.map