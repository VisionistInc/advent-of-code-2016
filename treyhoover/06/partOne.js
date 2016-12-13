const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');

const lines = input.split('\n');
const columnFreq = lines[0].split('').map(c => ({}));

lines.forEach(line => {
  line.split('').forEach((c, idx) => {
    columnFreq[idx][c] = (columnFreq[idx][c] || 0) + 1;
  });
});

console.log(columnFreq);

const answer = columnFreq.map((arr, idx) => {
  const keys = Object.keys(columnFreq[idx]);

  return keys.reduce((old, char) => {
    const count = columnFreq[idx][char];
    if (count > old.count) return { count, char };
    return old;
  }, { count: 0, char: ''}).char;
}).join('');

console.log(answer);
