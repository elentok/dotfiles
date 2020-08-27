import { URLSearchParams } from 'url'
import axios, { AxiosResponse } from 'axios'
import * as mqtt from 'mqtt'
import * as express from 'express'
import * as bodyParser from 'body-parser'
import { getConfig, getConfigOrDie } from './dotconfig'

const MQTT_HOST = getConfig('telegram_mqtt_host') || 'localhost'
const BOT_TOKEN = getConfigOrDie('telegram_bot_token')
const CHAT_ID = getConfigOrDie('telegram_chat_id')

function main(): void {
  const client = mqtt.connect(`mqtt://${MQTT_HOST}`)
  client.on('connect', () => client.subscribe('telegram:send'))
  client.on('message', (topic: string, message: Buffer) => {
    if (topic === 'telegram:send') {
      sendToTelegram(message.toString())
    }
  })

  const app = express()
  app.use(bodyParser.urlencoded({ extended: true }))
  app.post('/send', (req: express.Request, res: express.Response) => {
    console.info('Sending message', req.body.message)
    sendToTelegram(req.body.message).then(() => res.send('OK'))
  })
  app.listen(10000, () => console.info('Telegram proxy listening on port 10000'))

  sendToTelegram('*Telegram Proxy Started*')
}

async function sendToTelegram(message: string): Promise<void | AxiosResponse<any>> {
  const url = `https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`
  // eslint-disable-next-line camelcase
  const body = new URLSearchParams()
  body.set('chat_id', CHAT_ID)
  body.set('text', message)
  body.set('parse_mode', 'MarkdownV2')

  console.info('Making request to', url, 'with', body.toString())
  return axios.post(url, body.toString()).catch(err => {
    console.error('Error sending message:', err.message)
  })
}

main()

