module.exports = {
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
  }
};
