"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const chalk_1 = require("chalk");
const readline = require("readline");
const CLEAR_LINE = '\r\x1B[K';
const HOURGLASS = '⏳ ';
function justifyRight(text, width, ch = ' ') {
    while (text.length < width) {
        text = `${ch}${text}`;
    }
    return text;
}
exports.justifyRight = justifyRight;
function justifyLeft(text, width, ch = ' ') {
    while (text.length < width) {
        text = `${text}${ch}`;
    }
    return text;
}
exports.justifyLeft = justifyLeft;
function ask(question) {
    return __awaiter(this, void 0, void 0, function* () {
        return new Promise(resolve => {
            const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
            rl.question(question, answer => {
                rl.close();
                resolve(answer);
            });
        });
    });
}
exports.ask = ask;
function clearLine() {
    process.stdout.write(CLEAR_LINE);
}
exports.clearLine = clearLine;
function printProgress(message) {
    process.stdout.write(`${HOURGLASS} ${chalk_1.default.blue(message)}...`);
}
exports.printProgress = printProgress;
