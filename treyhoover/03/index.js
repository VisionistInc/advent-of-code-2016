const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');

const lines = input.split('\n');

const isValidTriangle = ([a, b, c]) => a + b > c && a + c > b && b + c > a;

const answer = lines.reduce((count, line) => {
  const triangle = line.trim().split(/\s+/).map(n => parseInt(n));
  return isValidTriangle(triangle) ? count + 1 : count;
}, 0);

console.log(answer);