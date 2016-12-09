const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');

// const numPad = [
//   ['1', '2', '3'],
//   ['4', '5', '6'],
//   ['7', '8', '9']
// ];

const numPad = [
  [' ', ' ', '1', ' ', ' '],
  [' ', '2', '3', '4', ' '],
  ['5', '6', '7', '8', '9'],
  [' ', 'A', 'B', 'C', ' '],
  [' ', ' ', 'D', ' ', ' ']
];

const position = { x: 1, y: 1 };
const lines = input.split('\n').map(line => line.split(''));

const isBlank = cell => typeof cell !== 'string' || !cell.trim();
const isValid = (x, y) => Array.isArray(numPad[y]) && !isBlank(numPad[y][x]);

const move = {
  U() {
    if (isValid(position.x, position.y - 1)) position.y--;
  },

  R() {
    if (isValid(position.x + 1, position.y)) position.x++;
  },

  D() {
    if (isValid(position.x, position.y + 1)) position.y++;
  },

  L() {
    if (isValid(position.x - 1, position.y)) position.x--;
  }
};

const getCurrentNumber = () => numPad[position.y][position.x];

const answer = lines.reduce((number, line) => {
  line.forEach(d => move[d] && move[d]());

  return number + getCurrentNumber();
}, '');

console.log(answer);
