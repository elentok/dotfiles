const axios = require('axios')
const fs = require('fs')
const path = require('path')

const CONFIG_FILE = path.join(process.env.HOME, '.config', 'openex.json')
const CACHE_FILE = path.join(process.env.HOME, '.cache', 'openex.json')
const CACHE_MAX_AGE_IN_HOURS = 12

const MAPPINGS = {
  $: 'USD',
  NIS: 'ILS'
}

const DEFAULTS = ['ILS', 'USD']

class Rates {
  constructor(data) {
    this.data = data
  }

  static get() {
    let stat

    try {
      stat = fs.statSync(CACHE_FILE)
    } catch (e) {
      return this.fetch()
    }

    const ageInMilliseconds = new Date() - stat.mtime
    const ageInHours = ageInMilliseconds / 1000 / 60 / 60
    if (ageInHours < CACHE_MAX_AGE_IN_HOURS) {
      const rates = new Rates(JSON.parse(fs.readFileSync(CACHE_FILE)))
      return Promise.resolve(rates)
    }

    return this.fetch()
  }

  static fetch() {
    const appId = this.getAppId()
    const url = `https://openexchangerates.org/api/latest.json?app_id=${appId}`
    return axios.get(url).then(response => {
      fs.writeFileSync(CACHE_FILE, JSON.stringify(response.data, null, 2))
      return new Rates(response.data)
    })
  }

  static getAppId() {
    if (!fs.existsSync(CONFIG_FILE)) {
      throw new Error(
        `Missing ~/.config/openex.json file (e.g. {"appId": "123..."})`
      )
    }

    const { appId } = JSON.parse(fs.readFileSync(CONFIG_FILE))
    return appId
  }

  convert(value, from, to) {
    from = this.normalize(from)
    to = this.normalize(to) || this.getDefaultTo(from)
    const fromRate = this.data.rates[from]
    const toRate = this.data.rates[to]

    return {
      value: value * toRate / fromRate,
      to
    }
  }

  getDefaultTo(from) {
    for (let i = 0; i < DEFAULTS.length; i++) {
      if (DEFAULTS[i] !== from) {
        return DEFAULTS[i]
      }
    }

    throw new Error("Can't find default target currency")
  }

  normalize(currency) {
    if (currency == null) return null

    currency = currency.toUpperCase()
    currency = MAPPINGS[currency] || currency
    if (this.data.rates[currency] == null) {
      throw new Error(`Invalid currency '${currency}'`)
    }

    return currency
  }
}

module.exports = Rates
