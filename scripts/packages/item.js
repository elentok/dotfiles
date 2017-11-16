const path = require('path')
const fs = require('fs')
const { getImagesDir, download } = require('./utils')

class Item {
  constructor(titleOrOptions) {
    if (typeof titleOrOptions === 'string') {
      this.title = titleOrOptions
    } else {
      const o = titleOrOptions
      this.id = o.id
      this.title = o.title
      this.img = o.img
      this.url = o.url
      this.cost = o.cost
      this.quantity = o.quantity
    }
  }

  toJSON() {
    const json = {}
    Object.keys(this).forEach(key => {
      if (this[key] != null) json[key] = this[key]
    })
    return json
  }

  downloadImage() {
    if (this.img == null) return Promise.resolve(true)

    const filename = path.join(getImagesDir(), `${this.id}.jpg`)
    if (fs.existsSync(filename)) return Promise.resolve(true)

    console.info(`Download image ${filename}`)
    return download(this.img, filename)
  }
}

module.exports = Item
