"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils_1 = require("./utils");
var TorrentStatus;
(function (TorrentStatus) {
    TorrentStatus[TorrentStatus["STOPPED"] = 0] = "STOPPED";
    TorrentStatus[TorrentStatus["CHECK_WAIT"] = 1] = "CHECK_WAIT";
    TorrentStatus[TorrentStatus["CHECK"] = 2] = "CHECK";
    TorrentStatus[TorrentStatus["DOWNLOAD_WAIT"] = 3] = "DOWNLOAD_WAIT";
    TorrentStatus[TorrentStatus["DOWNLOAD"] = 4] = "DOWNLOAD";
    TorrentStatus[TorrentStatus["SEED_WAIT"] = 5] = "SEED_WAIT";
    TorrentStatus[TorrentStatus["SEED"] = 6] = "SEED"; // 6  Seeding
})(TorrentStatus = exports.TorrentStatus || (exports.TorrentStatus = {}));
function isComplete(torrent) {
    return torrent.status === TorrentStatus.SEED || torrent.status === TorrentStatus.SEED_WAIT;
}
exports.isComplete = isComplete;
function isFailed(t) {
    return t.error !== 0;
}
exports.isFailed = isFailed;
function getError(t) {
    return isFailed(t) ? t.errorString : undefined;
}
exports.getError = getError;
function formatPercentDone(t) {
    return `${Math.floor(t.percentDone * 100)}%`;
}
function formatDownloadRate(t) {
    if (isComplete(t))
        return '';
    return `${t.rateDownload / 1000}kb/s`;
}
function formatTorrent(t) {
    return [
        utils_1.justifyLeft(TorrentStatus[t.status], 13),
        utils_1.justifyRight(formatPercentDone(t), 4),
        utils_1.justifyRight(formatDownloadRate(t), 8),
        t.name,
        getError(t)
    ].join(' ');
}
exports.formatTorrent = formatTorrent;
