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
const url_1 = require("url");
const axios_1 = require("axios");
const mqtt = require("mqtt");
const express = require("express");
const bodyParser = require("body-parser");
const dotconfig_1 = require("./dotconfig");
const MQTT_HOST = dotconfig_1.getConfig('telegram_mqtt_host') || 'localhost';
const BOT_TOKEN = dotconfig_1.getConfigOrDie('telegram_bot_token');
const CHAT_ID = dotconfig_1.getConfigOrDie('telegram_chat_id');
function main() {
    const client = mqtt.connect(`mqtt://${MQTT_HOST}`);
    client.on('connect', () => client.subscribe('telegram:send'));
    client.on('message', (topic, message) => {
        if (topic === 'telegram:send') {
            sendToTelegram(message.toString());
        }
    });
    const app = express();
    app.use(bodyParser.urlencoded({ extended: true }));
    app.post('/send', (req, res) => {
        console.info('Sending message', req.body.message);
        sendToTelegram(req.body.message).then(() => res.send('OK'));
    });
    app.listen(10000, () => console.info('Telegram proxy listening on port 10000'));
    sendToTelegram('Telegram Proxy Started');
}
function sendToTelegram(message) {
    return __awaiter(this, void 0, void 0, function* () {
        const url = `https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`;
        // eslint-disable-next-line camelcase
        const body = new url_1.URLSearchParams();
        body.set('chat_id', CHAT_ID);
        body.set('text', message);
        console.info('Making request to', url, 'with', body.toString());
        return axios_1.default.post(url, body.toString()).catch(err => {
            console.error('Error sending message:', err.message);
        });
    });
}
main();
