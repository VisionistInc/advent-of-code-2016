const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');
const lines = input.split('\n');

const unzip = (str, multiplier = 1) => {
  const start = str.indexOf('(');
  const stop = str.indexOf(')');

  if (start <= -1 || stop <= start) return str.length * multiplier;

  const selector = str.slice(start + 1, stop).split('x');
  const count = parseInt(selector[0]);
  const repeat = parseInt(selector[1]);

  const prev = str.slice(0, start);
  const next = str.slice(stop + 1, stop + count + 1);
  const remainder = str.slice(stop + count + 1, str.length);

  const compounded = unzip(next, multiplier * repeat);
  const carriedForward = unzip(remainder, multiplier);

  return prev.length + compounded + carriedForward;
};

lines.forEach(line => {
  const unzipped = unzip(line);
  console.log('unzipped', unzipped);
});
