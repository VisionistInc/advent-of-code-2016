const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');

const OFF = '.';
const ON = '#';

const createRow = (size) => OFF.repeat(size).split('');

const createGrid = (width, height) => {
  let grid = new Array(height);

  for (let i = 0; i < height; i++) {
    grid[i] = createRow(width);
  }

  return grid;
};

const turnOff = (x, y) => grid[y][x] = OFF;
const turnOn = (x, y) => grid[y][x] = ON;

const rect = (width, height) => {
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      turnOn(x, y);
    }
  }
};

const rotateRow = (y, _shift) => {
  const oldRow = grid[y].slice();
  const shift = _shift % oldRow.length;

  for (let x = 0; x < oldRow.length; x++) {
    const srcX = x - shift < 0 ? x - shift + oldRow.length : x - shift;
    grid[y][x] = oldRow[srcX];
  }
};

const rotateCol = (x, _shift) => {
  const shift = _shift % grid.length;
  const oldGrid = grid.slice().map(col => col.slice());

  for (let y = 0; y < oldGrid.length; y++) {
    const srcY = y - shift < 0 ? y - shift + grid.length : y - shift;
    grid[y][x] = oldGrid[srcY][x];
  }
};

let grid = createGrid(50, 6);

const printGrid = () => {
  console.log(grid.map(row => row.join('')).join('\n'), '\n');
};

input.split('\n').forEach(line => {
  const [command, ...args] = line.split(' ');

  if (command === 'rect') {
    const [width, height] = args[0].split('x');
    rect(width, height);
  } else if (command === 'rotate') {
    const [type, location, , offset] = args;

    if (type === 'row') {
      const [,y] = location.split('=');
      rotateRow(y, offset);
    } else if (type === 'column') {
      const [,x] = location.split('=');
      rotateCol(x, offset);
    }
  }

});

printGrid();

const numOn = grid.reduce((sum, row) => {
  const rowCount = row.reduce((rowSum, cell) => {
    return cell === ON ? rowSum + 1 : rowSum;
  }, 0);
  return sum + rowCount;
}, 0);

console.log(numOn);