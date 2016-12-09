const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');

const groups = [
  [[]],
  [[]],
  [[]]
];

input.split('\n').forEach(line => {
  const sides = line.trim().split(/\s+/).map(n => parseInt(n));

  sides.forEach((side, idx) => {
    const group = groups[idx];
    const lastGroup = group[group.length - 1];

    if (lastGroup.length === 3) {
      groups[idx].push([side])
    } else {
      lastGroup.push(side);
    }
  })
});

const triangles = [].concat(...groups);

const isValidTriangle = ([a, b, c]) => a + b > c && a + c > b && b + c > a;

const answer = triangles.reduce((count, triangle) => isValidTriangle(triangle) ? count + 1 : count, 0);

console.log(answer);