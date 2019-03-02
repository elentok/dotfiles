import * as program from 'commander'
import { BtClient } from './bt'
import { getConfigOrAsk } from './dotconfig'
import { formatTorrent } from './torrent'

let client: BtClient

async function main() {
  program.command('ls').action(async () => {
    const torrents = await (await getClient()).list()
    if (torrents.length === 0) {
      console.info('no torrents')
      return
    }
    torrents.forEach(t => console.info(formatTorrent(t)))
  })

  program.command('remove-complete').action(async () => {
    const torrents = await (await getClient()).removeComplete()
    if (torrents.length === 0) {
      console.info('No complete torrents to remove')
    } else {
      console.info(`Removed ${torrents.length} torrents:`)
      torrents.forEach(t => console.info(formatTorrent(t)))
    }
  })

  program.command('add-magnet <link>').action(async (link: string) => {
    const result = await (await getClient()).addMagnet(link)
    console.info(result)
  })

  program.parse(process.argv)

  if (process.argv.length === 2) program.help()
}

async function getClient(): Promise<BtClient> {
  if (client == null) {
    const host = await getConfigOrAsk('transmission_host', 'Transmission host? ')
    const port = Number(await getConfigOrAsk('transmission_port', 'Transmission port? '))
    const username = await getConfigOrAsk('transmission_username', 'Transmission username? ')
    const password = await getConfigOrAsk('transmission_password', 'Transmission password? ')

    client = await BtClient.create({ host, port, auth: { username, password } })
  }

  return client
}

main()
