const fs = require('fs')
const kdbxweb = require('kdbxweb')

class Database {
  constructor(filename, kdbx) {
    this._filename = filename
    this._kdbx = kdbx
  }

  getFilename() {
    return this._filename
  }

  getKdbx() {
    return this._kdbx
  }

  static createCreds(password) {
    return new kdbxweb.Credentials(kdbxweb.ProtectedValue.fromString(password))
  }

  static create(filename, name, password) {
    const creds = this.createCreds(password)
    const kdbx = kdbxweb.Kdbx.create(creds, name)
    kdbx.createRecycleBin()

    return new Database(filename, kdbx)
  }

  static load(filename, password) {
    const creds = this.createCreds(password)

    const arrayBuffer = fs.readFileSync(filename).buffer

    return kdbxweb.Kdbx.load(arrayBuffer, creds).then(
      kdbx => new Database(filename, kdbx)
    )
  }

  addEntry({
    title,
    username,
    password,
    notes,
    url,
    createdAt,
    updatedAt,
    binaries,
    trashed
  }) {
    let parentGroup = this._kdbx.getDefaultGroup()
    if (trashed) {
      parentGroup = this._kdbx.getGroup(this._kdbx.meta.recycleBinUuid)
    }

    const entry = this._kdbx.createEntry(parentGroup)
    entry.fields.Title = title
    entry.fields.UserName = username
    entry.fields.Password = kdbxweb.ProtectedValue.fromString(password)
    entry.fields.Notes = notes
    entry.fields.URL = url

    if (createdAt == null && updatedAt == null) {
      entry.times.update()
    } else {
      entry.times.creationTime = createdAt || new Date()
      entry.times.lastModTime = updatedAt || new Date()
    }

    Object.keys(binaries || []).forEach(filename => {
      entry.binaries[filename] = kdbxweb.ProtectedValue.fromBinary(
        binaries[filename]
      )
    })

    return entry
  }

  save() {
    return this._kdbx.save().then(arrayBuffer => {
      fs.writeFileSync(this._filename, Buffer.from(arrayBuffer))
    })
  }
}

module.exports = Database
