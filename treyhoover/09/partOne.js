const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');

const lines = input.split('\n');

let sum = 0;

lines.forEach(line => {
  let text = '';

  for (let i = 0; i < line.length; i++) {
    if (line[i] === '(') {
      let selector = '';

      while (line[++i] !== ')' && i < line.length) {
        selector += line[i];
      }

      const s = selector.split('x');
      const count = parseInt(s[0]);
      const repeat = parseInt(s[1]);

      if (i + count < line.length) {
        text += line.slice(i + 1, i + count + 1).repeat(repeat);
        i += count;
      }
    } else {
      text += line[i];
    }
  }

  console.log(text, text.length);
  sum += text.length;
});

console.log(sum);