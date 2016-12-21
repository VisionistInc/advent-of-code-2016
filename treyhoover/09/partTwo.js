const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');
const lines = input.split('\n');

const unzip = (str, callback) => {
  console.log(str.length);

  const start = str.indexOf('(');
  const stop = str.indexOf(')');
  const selector = str.slice(start + 1, stop).split('x');
  const count = parseInt(selector[0]);
  const repeat = parseInt(selector[1]);

  if (start > -1 && stop > start) {
    const beginning = str.slice(0, start);
    const repeated = str.slice(stop + 1, stop + count + 1).repeat(repeat);
    const end = str.slice(stop + count + 1, str.length);

    setTimeout(() => {
      unzip(beginning + repeated + end, callback);
    }, 0)
  } else {
    callback(str)
  }
};

lines.forEach(line => {
  unzip(line, text => {
    console.log(text.length);
  });
});
