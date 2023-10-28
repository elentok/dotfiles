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
exports.cyan = exports.blue = exports.yellow = exports.green = exports.red = exports.gray = exports.black = exports.confirm = exports.ask = exports.clearLine = exports.printProgress = void 0;
const readline = require("readline");
const COLORS = {
    black: "\x1B[30m",
    gray: "\x1B[1;30m",
    red: "\x1B[31m",
    green: "\x1B[32m",
    yellow: "\x1B[33m",
    blue: "\x1B[34m",
    cyan: "\x1B[36m",
};
const RESET = "\x1B[0m";
const CLEAR_LINE = "\r\x1B[K";
const HOURGLASS = "⏳ ";
function printProgress(message) {
    process.stdout.write(`${HOURGLASS} ${COLORS.blue}${message}...${RESET}`);
}
exports.printProgress = printProgress;
function clearLine() {
    process.stdout.write(CLEAR_LINE);
}
exports.clearLine = clearLine;
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
        const prettyQuestion = `${COLORS.yellow} ${question} [y/N]? ${RESET}`;
        const answer = yield ask(prettyQuestion);
        return /^[yY](es)?/.test(answer);
    });
}
exports.confirm = confirm;
function createColorFn(color) {
    return (text) => `${color}${text}${RESET}`;
}
exports.black = createColorFn(COLORS.black);
exports.gray = createColorFn(COLORS.gray);
exports.red = createColorFn(COLORS.red);
exports.green = createColorFn(COLORS.green);
exports.yellow = createColorFn(COLORS.yellow);
exports.blue = createColorFn(COLORS.blue);
exports.cyan = createColorFn(COLORS.cyan);
//# sourceMappingURL=framework.js.map