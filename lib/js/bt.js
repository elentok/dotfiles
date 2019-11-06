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
const axios_1 = require("axios");
const torrent_1 = require("./torrent");
function log(...args) {
    if (process.env.DEBUG === 'yes') {
        console.debug(...args);
    }
}
const SESSION_ID_HEADER = 'x-transmission-session-id';
class BtClient {
    constructor(reqConfig) {
        this.reqConfig = reqConfig;
        log('BtClient initialized', reqConfig);
    }
    static create(options = {}) {
        return __awaiter(this, void 0, void 0, function* () {
            const host = options.host || 'localhost';
            const port = options.port || 9091;
            const reqConfig = {
                baseURL: `http://${host}:${port}`,
                auth: options.auth
            };
            const headers = {};
            headers[SESSION_ID_HEADER] = yield getSessionId(reqConfig);
            return new BtClient(Object.assign(Object.assign({}, reqConfig), { headers }));
        });
    }
    list() {
        return __awaiter(this, void 0, void 0, function* () {
            const response = yield this.rpcCall('torrent-get', {
                fields: 'id name status percentDone rateDownload magnetLink error errorString'.split(' ')
            });
            return response.data.arguments.torrents;
        });
    }
    addMagnet(link, options = {}) {
        return __awaiter(this, void 0, void 0, function* () {
            options = Object.assign({ paused: false }, options);
            const response = yield this.rpcCall('torrent-add', {
                paused: options.paused,
                filename: link
            });
            return response.data.arguments;
        });
    }
    removeComplete() {
        return __awaiter(this, void 0, void 0, function* () {
            const completeTorrents = (yield this.list()).filter(torrent_1.isComplete);
            yield this.remove(completeTorrents.map(t => t.id));
            return completeTorrents;
        });
    }
    remove(ids) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.rpcCall('torrent-remove', { ids });
        });
    }
    rpcCall(method, args) {
        return __awaiter(this, void 0, void 0, function* () {
            return yield axios_1.default.post('/transmission/rpc', { method, arguments: args }, this.reqConfig);
        });
    }
}
exports.BtClient = BtClient;
function getSessionId(reqConfig) {
    return __awaiter(this, void 0, void 0, function* () {
        log('Getting settion id...');
        let id;
        try {
            const response = yield axios_1.default.get(`/transmission/rpc`, reqConfig);
            id = response.headers[SESSION_ID_HEADER];
        }
        catch (err) {
            id = err.response.headers[SESSION_ID_HEADER];
        }
        log(`Got session id: ${id}`);
        return id;
    });
}
