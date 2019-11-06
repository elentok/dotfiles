import { justifyRight, justifyLeft } from './utils'

export enum TorrentStatus {
  STOPPED = 0, // 0, Torrent is stopped
  CHECK_WAIT, // 1, Queued to check files
  CHECK, // 2, Checking files
  DOWNLOAD_WAIT, // 3, Queued to download
  DOWNLOAD, // 4, Downloading
  SEED_WAIT, // 5, Queued to seed
  SEED // 6  Seeding
}

export interface Torrent {
  id: string
  name: string
  status: number
  percentDone: number
  rateDownload: number
  magnetLink: number
  error: number
  errorString: string
}

export function isComplete(torrent: Torrent): boolean {
  return torrent.status === TorrentStatus.SEED || torrent.status === TorrentStatus.SEED_WAIT
}

export function isFailed(t: Torrent): boolean {
  return t.error !== 0
}

export function getError(t: Torrent): string | undefined {
  return isFailed(t) ? t.errorString : undefined
}

function formatPercentDone(t: Torrent): string {
  return `${Math.floor(t.percentDone * 100)}%`
}

function formatDownloadRate(t: Torrent): string {
  if (isComplete(t)) return ''

  return `${t.rateDownload / 1000}kb/s`
}

export function formatTorrent(t: Torrent): string {
  return [
    justifyLeft(TorrentStatus[t.status], 13),
    justifyRight(formatPercentDone(t), 4),
    justifyRight(formatDownloadRate(t), 8),
    t.name,
    getError(t)
  ].join(' ')
}
