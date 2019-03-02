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
const axios_1 = require("axios");
const fs = require("fs");
const os = require("os");
const path = require("path");
const dotconfig_1 = require("./dotconfig");
const CACHE_FILE = path.join(os.homedir(), '.cache', 'openex.json');
const CACHE_MAX_AGE_IN_HOURS = 12;
const MAPPINGS = {
    $: 'USD',
    NIS: 'ILS'
};
const DEFAULTS = ['ILS', 'USD'];
class Rates {
    constructor(data) {
        this.data = data;
    }
    convert(from, toCurrency) {
        const fromCurrency = this.normalize(from.currency);
        toCurrency = this.normalize(toCurrency) || this.getDefaultTo(fromCurrency);
        const fromRate = this.data.rates[fromCurrency];
        const toRate = this.data.rates[toCurrency];
        return {
            value: from.value * toRate / fromRate,
            currency: toCurrency
        };
    }
    getDefaultTo(from) {
        for (let i = 0; i < DEFAULTS.length; i++) {
            if (DEFAULTS[i] !== from) {
                return DEFAULTS[i];
            }
        }
        throw new Error("Can't find default target currency");
    }
    normalize(currency) {
        if (currency == null)
            return;
        currency = currency.toUpperCase();
        currency = MAPPINGS[currency] || currency;
        if (this.data.rates[currency] == null) {
            throw new Error(`Invalid currency '${currency}'`);
        }
        return currency;
    }
}
exports.Rates = Rates;
let rates;
function convert(from, toCurrency) {
    return __awaiter(this, void 0, void 0, function* () {
        return (yield getRates()).convert(from, toCurrency);
    });
}
exports.convert = convert;
function getRates() {
    return __awaiter(this, void 0, void 0, function* () {
        if (rates == null) {
            rates = getCachedRates() || (yield fetchRates());
        }
        return rates;
    });
}
exports.getRates = getRates;
function getCachedRates() {
    if (!isCacheFresh())
        return;
    return new Rates(JSON.parse(fs.readFileSync(CACHE_FILE).toString()));
}
function isCacheFresh() {
    let stat;
    try {
        stat = fs.statSync(CACHE_FILE);
    }
    catch (e) {
        return false;
    }
    const ageInMilliseconds = Date.now() - stat.mtime.getTime();
    const ageInHours = ageInMilliseconds / 1000 / 60 / 60;
    return ageInHours < CACHE_MAX_AGE_IN_HOURS;
}
function fetchRates() {
    return __awaiter(this, void 0, void 0, function* () {
        const appId = yield getOpenExchangeAppId();
        const url = `https://openexchangerates.org/api/latest.json?app_id=${appId}`;
        return axios_1.default.get(url).then(response => {
            fs.writeFileSync(CACHE_FILE, JSON.stringify(response.data, null, 2));
            return new Rates(response.data);
        });
    });
}
function getOpenExchangeAppId() {
    return __awaiter(this, void 0, void 0, function* () {
        return dotconfig_1.getConfigOrAsk('open_exchange_app_id', 'OpenExchange app id? ');
    });
}
exports.getOpenExchangeAppId = getOpenExchangeAppId;
