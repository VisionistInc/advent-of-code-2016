var fs = require('fs');

fs.readFile('input.txt', 'utf8', function(error, data) {
  if (error) {
    console.error(error);
    return;
  }

  var lines = data.split("\n");
  var letters = lines.map(line => line.split("").map(letter => ({ [letter]: 1 })));
  var columnCounts = letters.reduce(function(left, right) {
    right.forEach(function(column, index) {
      if (typeof left[index] === 'undefined' || left[index] === null) {
        left[index] = {};
      }

      Object.keys(column).forEach(key => {
        if (left[index][key]) {
          left[index][key] += column[key];
        } else {
          left[index][key] = column[key];
        }
      });
    });

    return left;
  }, letters[0].map(_ => {}));

  var mostPopular = columnCounts.map(function(column) {
    var max = 0, maxKey = null;
    Object.keys(column).forEach(function(key) {
      if (maxKey === null || column[key] > max) max = column[key], maxKey = key;
    });
    return maxKey;
  });

  var leastPopular = columnCounts.map(function(column) {
    var min = 0, minKey = null;
    Object.keys(column).forEach(function(key) {
      if (minKey === null || column[key] < min) min = column[key], minKey = key;
    });
    return minKey;
  });

  console.log(mostPopular.join(""));
  console.log(leastPopular.join(""));
});
