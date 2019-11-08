"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = require("fs");
const vm_1 = require("vm");
const context = vm_1.createContext();
function sum(lines) {
    return lines.reduce((sum, line) => {
        return sum + vm_1.runInContext(line.split(' ')[0], context);
    }, 0);
}
exports.sum = sum;
const input = fs_1.readFileSync(0, 'utf-8')
    .trim()
    .toString();
const totalSum = sum(input.split('\n')).toFixed(3);
console.info(`${input}

  = ${totalSum}`);
