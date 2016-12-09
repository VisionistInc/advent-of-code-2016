const fs = require('fs');
const input = fs.readFileSync('index.txt', 'utf-8');

const numPad = [
  ['1', '2', '3'],
  ['4', '5', '6'],
  ['7', '8', '9']
];

const position = { x: 1, y: 1 };
const lines = input.split('\n').map(line => line.split(''));

const move = {
  up() {
    if (position.y > 0) position.y--;
  },

  right() {
    if (position.x < 2) position.x++;
  },

  down() {
    if (position.y < 2) position.y++;
  },

  left() {
    if (position.x > 0) position.x--;
  }
};

const getCurrentNumber = () => numPad[position.y][position.x];

const answer = lines.reduce((number, line) => {
  line.forEach(d => {
    if (d === 'U') move.up();
    if (d === 'R') move.right();
    if (d === 'D') move.down();
    if (d === 'L') move.left();
  });

  return number + getCurrentNumber();
}, '');

console.log(answer);