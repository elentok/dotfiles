"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.stringifyDateOnly = exports.notUndefined = exports.printProgress = exports.clearLine = exports.confirm = exports.ask = exports.center = exports.justifyLeft = exports.justifyRight = void 0;
const chalk = require("chalk");
const readline = require("readline");
const CLEAR_LINE = '\r\x1B[K';
const HOURGLASS = '⏳ ';
function justifyRight(text, width, ch = ' ') {
    if (text.length >= width)
        return text;
    const leftPad = width - text.length;
    return `${ch.repeat(leftPad)}${text}`;
}
exports.justifyRight = justifyRight;
function justifyLeft(text, width, ch = ' ') {
    if (text.length >= width)
        return text;
    const rightPad = width - text.length;
    return `${text}${ch.repeat(rightPad)}`;
}
exports.justifyLeft = justifyLeft;
function center(text, width, ch = ' ') {
    if (text.length >= width)
        return text;
    const leftPad = Math.floor((width - text.length) / 2);
    const rightPad = width - text.length - leftPad;
    return `${ch.repeat(leftPad)}${text}${ch.repeat(rightPad)}`;
}
exports.center = center;
function ask(question) {
    return __awaiter(this, void 0, void 0, function* () {
        return new Promise((resolve) => {
            const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
            rl.question(question, (answer) => {
                rl.close();
                resolve(answer);
            });
        });
    });
}
exports.ask = ask;
function confirm(question) {
    return __awaiter(this, void 0, void 0, function* () {
        const prettyQuestion = chalk.yellow(`${question} [y/N]? `);
        const answer = yield ask(prettyQuestion);
        return /^[yY](es)?/.test(answer);
    });
}
exports.confirm = confirm;
function clearLine() {
    process.stdout.write(CLEAR_LINE);
}
exports.clearLine = clearLine;
function printProgress(message) {
    process.stdout.write(`${HOURGLASS} ${chalk.blue(message)}...`);
}
exports.printProgress = printProgress;
function notUndefined(x) {
    return x !== undefined;
}
exports.notUndefined = notUndefined;
function stringifyDateOnly(date) {
    const month = justifyLeft(date.getMonth().toString(), 2, '0');
    const day = justifyLeft(date.getDate().toString(), 2, '0');
    return `${date.getFullYear()}-${month}-${day}`;
}
exports.stringifyDateOnly = stringifyDateOnly;
//# sourceMappingURL=utils.js.map