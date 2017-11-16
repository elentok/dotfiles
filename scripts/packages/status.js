const ALL = [
  'unknown',
  'processing',
  'shipped',
  'in-transit', // this means the tracking number is active
  'shufersal',
  'delivered',
  'on-hold'
]

let nextValue = ALL.length

class Status {
  constructor(name, value) {
    this.name = name
    this.value = value
  }

  static fromName(name) {
    if (name instanceof Status) return name

    if (name == null) name = 'unknown'
    if (typeof name !== 'string') {
      throw new Error(
        `Trying to identify non-string status ${JSON.stringify(name)}`
      )
    }
    name = this.normalizeName(name)
    let status = this._byName[name]
    if (status != null) return status

    status = new Status(name, nextValue++)
    this._all.push(status)
    this._byName[name] = status
    return status
  }

  static normalizeName(name) {
    return name.toLowerCase().replace(/ /g, '-')
  }

  static all() {
    return this._all
  }

  static _init() {
    this._all = ALL.map((name, index) => new Status(name, index))
    this._byName = {}
    this._all.forEach(status => (this._byName[status.name] = status))
  }

  toJSON() {
    return this.name
  }
}

Status._init()

module.exports = Status
