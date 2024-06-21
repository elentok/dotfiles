#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run --allow-net

// import * as mqtt from "npm:mqtt"
import { getConfig, getConfigOrDie } from "./dotconfig.ts"

// const MQTT_HOST = getConfig("telegram_mqtt_host") || "localhost"
const BOT_TOKEN = getConfigOrDie("telegram_bot_token")
const CHAT_ID = getConfigOrDie("telegram_chat_id")

enum ParseMode {
  HTML = "HTML",
  MarkdownV2 = "MarkdownV2",
}

async function handler(request: Request): Promise<Response> {
  if (request.method === "POST" && request.body) {
    const data = await request.formData()
    const parseMode = parseParseMode(data.get("parseMode")?.toString())
    const message = data.get("message")?.toString()

    if (message == null) {
      return new Response("Error: Missing 'message' field", { status: 400 })
    }

    console.info(`Sending message ${message} with parse mode ${parseMode}`)
    const response = await sendToTelegram(message, parseMode)
    if (response && response.ok) {
      return new Response("OK", { status: 200 })
    }
    return new Response("Error: Telegram request failed", { status: 500 })
  }

  return new Response("Usage: POST parseMode=HTML/MarkdownV2&message=Hello")
}

function main(): void {
  // startMqttServer()

  setTimeout(() => {
    console.info("Telegram proxy listening on port 10000"),
      sendToTelegram("*Telegram Proxy Started*", ParseMode.MarkdownV2)
  }, 100)

  Deno.serve({ port: 10000 }, handler)
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
  parseMode = ParseMode.HTML,
): Promise<void | Response> {
  const url = `https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`
  const body = {
    // eslint-disable-next-line @typescript-eslint/camelcase
    chat_id: CHAT_ID,
    text: message,
    // eslint-disable-next-line @typescript-eslint/camelcase
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
