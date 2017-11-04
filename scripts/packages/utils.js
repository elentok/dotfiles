const path = require("path");
const fs = require("fs");
const axios = require("axios");

const Utils = {
  leftPad(number, totalLength, char = "0") {
    let output = number.toString();

    while (output.length < totalLength) {
      output = `${char}${output}`;
    }

    return output;
  },

  max(array, predicate) {
    let maxItem = null;
    let maxValue = null;

    array.forEach(item => {
      const value = predicate(item);

      if (maxItem == null || value > maxValue) {
        maxItem = item;
        maxValue = value;
      }
    });

    return maxItem;
  },

  getDataDir() {
    const dir = path.join(process.env.HOME, ".config", "packages");
    if (!fs.existsSync(dir)) fs.mkdirSync(dir);
    return dir;
  },

  getImagesDir() {
    const imagesDir = path.join(Utils.getDataDir(), "images");
    if (!fs.existsSync(imagesDir)) fs.mkdirSync(imagesDir);
    return imagesDir;
  },

  download(url, outputFilename) {
    axios.get(url, { responseType: "arraybuffer" }).then(response => {
      fs.writeFileSync(outputFilename, response.data);
    });
  }
};

module.exports = Utils;
