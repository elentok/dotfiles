import { URLSearchParams } from 'url'
import axios, { AxiosResponse } from 'axios'
import * as mqtt from 'mqtt'
import * as express from 'express'
import * as bodyParser from 'body-parser'
import { getConfig, getConfigOrDie } from './dotconfig'

const MQTT_HOST = getConfig('telegram_mqtt_host') || 'localhost'
const BOT_TOKEN = getConfigOrDie('telegram_bot_token')
const CHAT_ID = getConfigOrDie('telegram_chat_id')

enum ParseMode {
  HTML = 'HTML',
  MarkdownV2 = 'MarkdownV2'
}

function main(): void {
  const client = mqtt.connect(`mqtt://${MQTT_HOST}`)
  client.on('connect', () => client.subscribe('telegram:send'))
  client.on('message', (topic: string, message: Buffer) => {
    if (topic === 'telegram:send') {
      sendToTelegram(message.toString(), ParseMode.HTML)
    }
  })

  const app = express()
  app.use(bodyParser.urlencoded({ extended: true }))
  app.post('/send', (req: express.Request, res: express.Response) => {
    const parseMode = parseParseMode(req.body.parseMode)
    console.info(`Sending message ${req.body.message} with parse mode ${parseMode}`)
    sendToTelegram(req.body.message, parseMode).then(() => res.send('OK'))
  })
  app.listen(10000, () => console.info('Telegram proxy listening on port 10000'))

  sendToTelegram('*Telegram Proxy Started*', ParseMode.MarkdownV2)
}

async function sendToTelegram(
  message: string,
  parseMode = ParseMode.HTML
): Promise<void | AxiosResponse<any>> {
  const url = `https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`
  const body = {
    // eslint-disable-next-line @typescript-eslint/camelcase
    chat_id: CHAT_ID,
    text: message,
    // eslint-disable-next-line @typescript-eslint/camelcase
    parse_mode: parseMode
  }

  console.info('Making request to', url, 'with', JSON.stringify(body))
  return axios.post(url, body).catch(err => {
    console.error('Error sending message:', err.message)
  })
}

function parseParseMode(value?: string): ParseMode {
  if (value == ParseMode.MarkdownV2) return ParseMode.MarkdownV2
  return ParseMode.HTML
}

main()
