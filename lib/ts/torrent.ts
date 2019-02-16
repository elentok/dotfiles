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

export interface ITorrent {
  id: string
  name: string
  status: number
  percentDone: number
  rateDownload: number
  magnetLink: number
  error: number
  errorString: string
}

export function isComplete(torrent: ITorrent): boolean {
  return torrent.status === TorrentStatus.SEED || torrent.status === TorrentStatus.SEED_WAIT
}

export function isFailed(t: ITorrent): boolean {
  return t.error !== 0
}

export function getError(t: ITorrent): string | undefined {
  return isFailed(t) ? t.errorString : undefined
}

export function formatTorrent(t: ITorrent): string {
  return [
    justifyLeft(TorrentStatus[t.status], 13),
    justifyRight(formatPercentDone(t), 4),
    justifyRight(formatDownloadRate(t), 8),
    t.name,
    getError(t)
  ].join(' ')
}

function formatPercentDone(t: ITorrent): string {
  return `${Math.floor(t.percentDone * 100)}%`
}

function formatDownloadRate(t: ITorrent): string {
  if (isComplete(t)) return ''

  return `${t.rateDownload / 1000}kb/s`
}

// def percent_s
// "#{(@percent * 100).to_i}%"
// end
