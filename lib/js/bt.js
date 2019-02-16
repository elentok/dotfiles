"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class BtClient {
    constructor(options = {}) {
        this.options = Object.assign({ host: 'localhost', port: 9091 }, options);
    }
}
exports.BtClient = BtClient;
