import axios, { AxiosRequestConfig, AxiosBasicCredentials, AxiosResponse } from 'axios'
import { Torrent, isComplete } from './torrent'

export interface IBtOptions {
  host: string
  port: number
  auth?: AxiosBasicCredentials
}

function log(...args: any[]): void {
  if (process.env.DEBUG === 'yes') {
    console.debug(...args)
  }
}

const SESSION_ID_HEADER = 'x-transmission-session-id'

export class BtClient {
  public static async create(options: Partial<IBtOptions> = {}): Promise<BtClient> {
    const host = options.host || 'localhost'
    const port = options.port || 9091
    const reqConfig: AxiosRequestConfig = {
      baseURL: `http://${host}:${port}`,
      auth: options.auth
    }
    const headers: { [key: string]: string } = {}
    headers[SESSION_ID_HEADER] = await getSessionId(reqConfig)

    return new BtClient({ ...reqConfig, headers })
  }

  private constructor(private reqConfig: AxiosRequestConfig) {
    log('BtClient initialized', reqConfig)
  }

  public async list(): Promise<Torrent[]> {
    const response = await this.rpcCall('torrent-get', {
      fields: 'id name status percentDone rateDownload magnetLink error errorString'.split(' ')
    })

    return response.data.arguments.torrents as Torrent[]
  }

  public async addMagnet(link: string, options: { paused?: boolean } = {}): Promise<any> {
    options = { paused: false, ...options }
    const response = await this.rpcCall('torrent-add', {
      paused: options.paused,
      filename: link
    })
    return response.data.arguments
  }

  public async removeComplete(): Promise<Torrent[]> {
    const completeTorrents = (await this.list()).filter(isComplete)
    await this.remove(completeTorrents.map(t => t.id))
    return completeTorrents
  }

  public async remove(ids: string[]): Promise<void> {
    await this.rpcCall('torrent-remove', { ids })
  }

  private async rpcCall(method: string, args: any): Promise<AxiosResponse> {
    return await axios.post('/transmission/rpc', { method, arguments: args }, this.reqConfig)
  }
}

async function getSessionId(reqConfig: AxiosRequestConfig): Promise<string> {
  log('Getting settion id...')
  let id: string
  try {
    const response = await axios.get(`/transmission/rpc`, reqConfig)
    id = response.headers[SESSION_ID_HEADER]
  } catch (err) {
    id = err.response.headers[SESSION_ID_HEADER]
  }

  log(`Got session id: ${id}`)
  return id
}
