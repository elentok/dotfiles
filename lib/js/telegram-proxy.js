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
const mqtt = require("mqtt");
const express = require("express");
const bodyParser = require("body-parser");
const dotconfig_1 = require("./dotconfig");
const MQTT_HOST = dotconfig_1.getConfig('telegram_mqtt_host') || 'localhost';
const BOT_TOKEN = dotconfig_1.getConfigOrDie('telegram_bot_token');
const CHAT_ID = dotconfig_1.getConfigOrDie('telegram_chat_id');
var ParseMode;
(function (ParseMode) {
    ParseMode["HTML"] = "HTML";
    ParseMode["MarkdownV2"] = "MarkdownV2";
})(ParseMode || (ParseMode = {}));
function main() {
    const client = mqtt.connect(`mqtt://${MQTT_HOST}`);
    client.on('connect', () => client.subscribe('telegram:send'));
    client.on('message', (topic, message) => {
        if (topic === 'telegram:send') {
            sendToTelegram(message.toString(), ParseMode.HTML);
        }
    });
    const app = express();
    app.use(bodyParser.urlencoded({ extended: true }));
    app.post('/send', (req, res) => {
        const parseMode = parseParseMode(req.body.parseMode);
        console.info(`Sending message ${req.body.message} with parse mode ${parseMode}`);
        sendToTelegram(req.body.message, parseMode).then(() => res.send('OK'));
    });
    app.listen(10000, () => console.info('Telegram proxy listening on port 10000'));
    sendToTelegram('*Telegram Proxy Started*', ParseMode.MarkdownV2);
}
function sendToTelegram(message, parseMode = ParseMode.HTML) {
    return __awaiter(this, void 0, void 0, function* () {
        const url = `https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`;
        const body = {
            // eslint-disable-next-line @typescript-eslint/camelcase
            chat_id: CHAT_ID,
            text: message,
            // eslint-disable-next-line @typescript-eslint/camelcase
            parse_mode: parseMode
        };
        console.info('Making request to', url, 'with', JSON.stringify(body));
        return axios_1.default.post(url, body).catch(err => {
            console.error('Error sending message:', err.message);
        });
    });
}
function parseParseMode(value) {
    if (value == ParseMode.MarkdownV2)
        return ParseMode.MarkdownV2;
    return ParseMode.HTML;
}
main();
//# sourceMappingURL=telegram-proxy.js.map