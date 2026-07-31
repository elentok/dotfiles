#!/usr/bin/env node

import { createServer, type IncomingMessage, type ServerResponse } from "node:http"
import { getConfigOrDie } from "./dotconfig.ts"

// const MQTT_HOST = getConfig("telegram_mqtt_host") || "localhost"
const BOT_TOKEN = getConfigOrDie("telegram_bot_token")
const CHAT_ID = getConfigOrDie("telegram_chat_id")

const ParseMode = {
  HTML: "HTML",
  MarkdownV2: "MarkdownV2",
} as const
type ParseMode = typeof ParseMode[keyof typeof ParseMode]

function readBody(request: IncomingMessage): Promise<string> {
  return new Promise((resolve, reject) => {
    const chunks: Buffer[] = []
    request.on("data", (chunk: Buffer) => chunks.push(chunk))
    request.on("end", () => resolve(Buffer.concat(chunks).toString("utf8")))
    request.on("error", reject)
  })
}

async function handler(
  request: IncomingMessage,
  response: ServerResponse,
): Promise<void> {
  if (request.method === "POST") {
    const body = await readBody(request)
    const data = new URLSearchParams(body)
    const parseMode = parseParseMode(data.get("parseMode") ?? undefined)
    const message = data.get("message")

    if (message == null) {
      response.writeHead(400)
      response.end("Error: Missing 'message' field")
      return
    }

    console.info(`Sending message ${message} with parse mode ${parseMode}`)
    const telegramResponse = await sendToTelegram(message, parseMode)
    if (telegramResponse && telegramResponse.ok) {
      response.writeHead(200)
      response.end("OK")
      return
    }
    response.writeHead(500)
    response.end("Error: Telegram request failed")
    return
  }

  response.writeHead(200)
  response.end("Usage: POST parseMode=HTML/MarkdownV2&message=Hello")
}

function main(): void {
  // startMqttServer()

  setTimeout(() => {
    console.info("Telegram proxy listening on port 10000"),
      sendToTelegram("*Telegram Proxy Started*", ParseMode.MarkdownV2)
  }, 100)

  createServer((request, response) => {
    handler(request, response).catch((error) => {
      console.error(error)
      response.writeHead(500)
      response.end("Error: internal error")
    })
  }).listen(10000)
}

// function startMqttServer() {
//   const client = mqtt.connect(`mqtt://${MQTT_HOST}`)
//   client.on("connect", () => client.subscribe("telegram:send"))
//   client.on("message", (topic, message) => {
//     if (topic === "telegram:send") {
//       sendToTelegram(message.toString(), ParseMode.HTML)
//     }
//   })
// }

async function sendToTelegram(
  message: string,
  parseMode: ParseMode = ParseMode.HTML,
): Promise<void | Response> {
  const url = `https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`
  const body = {
    chat_id: CHAT_ID,
    text: message,
    parse_mode: parseMode,
  }

  console.info("Making request to", url, "with", JSON.stringify(body))
  const response = await fetch(url, {
    method: "post",
    body: new URLSearchParams(body),
  })
  if (!response.ok) {
    console.error("Error sending message:", await response.text())
  }
  return response
}

function parseParseMode(value?: string): ParseMode {
  if (value == ParseMode.MarkdownV2) return ParseMode.MarkdownV2
  return ParseMode.HTML
}

main()
