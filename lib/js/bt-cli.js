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
const bt_1 = require("./bt");
const torrent_1 = require("./torrent");
const dotconfig_1 = require("./dotconfig");
const program = require("commander");
let client;
function main() {
    return __awaiter(this, void 0, void 0, function* () {
        program.command('ls').action(() => __awaiter(this, void 0, void 0, function* () {
            const torrents = yield (yield getClient()).list();
            torrents.forEach(t => console.info(torrent_1.formatTorrent(t)));
        }));
        program.command('remove-complete').action(() => __awaiter(this, void 0, void 0, function* () {
            const torrents = yield (yield getClient()).removeComplete();
            if (torrents.length === 0) {
                console.info('No complete torrents to remove');
            }
            else {
                console.info(`Removed ${torrents.length} torrents:`);
                torrents.forEach(t => console.info(torrent_1.formatTorrent(t)));
            }
        }));
        program.command('add-magnet <link>').action((link) => __awaiter(this, void 0, void 0, function* () {
            const result = yield (yield getClient()).addMagnet(link);
            console.info(result);
        }));
        program.parse(process.argv);
        if (process.argv.length === 2)
            program.help();
    });
}
function getClient() {
    return __awaiter(this, void 0, void 0, function* () {
        if (client == null) {
            const host = yield dotconfig_1.getConfigOrAsk('transmission_host', 'Transmission host? ');
            const port = Number(yield dotconfig_1.getConfigOrAsk('transmission_port', 'Transmission port? '));
            const username = yield dotconfig_1.getConfigOrAsk('transmission_username', 'Transmission username? ');
            const password = yield dotconfig_1.getConfigOrAsk('transmission_password', 'Transmission password? ');
            client = yield bt_1.BtClient.create({ host, port, auth: { username, password } });
        }
        return client;
    });
}
main();
