"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("../utils");
class Remote {
    constructor(repo, name) {
        this.repo = repo;
        this.name = name;
        this.name = name;
    }
    fetch() {
        utils_1.printProgress(`Fetching remote '${this.name}'`);
        this.repo.git(`fetch ${this.name}`);
        utils_1.clearLine();
    }
    prune() {
        utils_1.printProgress(`Removing dead branches from '${this.name}'`);
        this.repo.git(`remote prune ${this.name}`);
        utils_1.clearLine();
    }
}
exports.Remote = Remote;
