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
const fs = require("fs");
const os = require("os");
const path = require("path");
const utils_1 = require("./utils");
const child_process_1 = require("child_process");
exports.CONFIG_DIR = path.join(os.homedir(), '.config', 'dotfiles');
exports.CONFIG_FILE = path.join(exports.CONFIG_DIR, 'config');
let configLines = [];
function initialize() {
    if (!fs.existsSync(exports.CONFIG_FILE))
        return;
    configLines = fs
        .readFileSync(exports.CONFIG_FILE)
        .toString()
        .trim()
        .split('\n')
        .map(parseLine);
}
function parseLine(line) {
    if (/^[#\s]/.test(line))
        return line;
    const index = line.indexOf('=');
    if (index === -1)
        return line;
    return {
        key: line.substring(0, index),
        value: line.substring(index + 1)
    };
}
function findItem(key) {
    return configLines.find(l => typeof l === 'object' && l.key === key);
}
function findItemIndex(key) {
    return configLines.findIndex(l => typeof l === 'object' && l.key === key);
}
function getConfig(key) {
    const item = findItem(key);
    if (item != null)
        return item.value;
}
exports.getConfig = getConfig;
function setConfig(key, value) {
    const index = findItemIndex(key);
    if (index === -1) {
        configLines.push({ key, value });
    }
    else {
        configLines[index] = { key, value };
    }
    save();
}
exports.setConfig = setConfig;
function save() {
    if (!fs.existsSync(exports.CONFIG_DIR))
        child_process_1.execSync(`mkdir -p "${exports.CONFIG_DIR}"`);
    const body = configLines
        .map(line => (typeof line === 'object' ? `${line.key}=${line.value}` : line))
        .join('\n');
    fs.writeFileSync(exports.CONFIG_FILE, body);
}
function getConfigOrAsk(key, question) {
    return __awaiter(this, void 0, void 0, function* () {
        const item = findItem(key);
        if (item != null)
            return item.value;
        let value;
        while (value == null) {
            value = yield utils_1.ask(question);
        }
        setConfig(key, value);
        return value;
    });
}
exports.getConfigOrAsk = getConfigOrAsk;
initialize();
