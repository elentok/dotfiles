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
require("source-map-support/register");
const chalk = require("chalk");
const os = require("os");
const path = require("path");
const repl = require("repl");
const utils_1 = require("./utils");
const rates_1 = require("./rates");
const vm_1 = require("vm");
const context = vm_1.createContext();
const REPL_HISTORY_FILE = path.join(os.homedir(), '.cache', 'calc');
function main() {
    return __awaiter(this, void 0, void 0, function* () {
        yield rates_1.getOpenExchangeAppId();
        const server = repl.start({
            prompt: '> ',
            eval(cmd, _context, _filename, callback) {
                calculate(cmd)
                    .catch((err) => {
                    console.error('Error evaluating: ', err);
                    callback(err);
                })
                    .then((result) => callback(null, result));
            },
            writer(output) {
                return '= ' + chalk.green(output) + '\n';
            },
        });
        const anyServer = server;
        anyServer.setupHistory(REPL_HISTORY_FILE, (err) => {
            if (err != null)
                console.error('Error writing history', err);
        });
    });
}
function calculate(expr) {
    return __awaiter(this, void 0, void 0, function* () {
        const c = parseCurrencyExpression(expr);
        if (c != null && c.toCurrency != null) {
            const result = yield rates_1.convert(c.from, c.toCurrency);
            if (result == null) {
                throw new Error(`failed converting "${c.from}" to "${c.toCurrency}"`);
            }
            return `${result.value.toFixed(2)} ${result.currency}`;
        }
        const value = vm_1.runInContext(expr, context);
        return value;
    });
}
function parseCurrencyExpression(expr) {
    const match = expr.match(/([\d.]+)\s*([a-zA-Z$]+)(\s+to\s+([a-zA-Z$]+))?/);
    if (match == null)
        return;
    const matches = match.filter(utils_1.notUndefined);
    // "123.45 nis to usd"
    if (matches.length === 5) {
        return {
            from: { value: parseFloat(match[1]), currency: match[2] },
            toCurrency: match[4],
        };
    }
    // "123.45 nis"
    if (matches.length === 3) {
        const currency = match[2];
        const toCurrency = ['nis', 'ils'].includes(currency.toLowerCase()) ? '$' : 'nis';
        return {
            from: { value: parseFloat(match[1]), currency },
            toCurrency,
        };
    }
    return;
}
main();
//# sourceMappingURL=calc.js.map