const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');

const sorter = ([freqA, a], [freqB, b]) => freqA === freqB ? a.charCodeAt(0) - b.charCodeAt(0) : freqB - freqA;

const answer = input.split('\n').reduce((sum, line) => {
  const [, name, id, checkSum] = line.match(/([\w-]+)-(\d+)\[(\w+)\]/);
  const freqTable = name.match(/([a-zA-Z])/g).reduce((acc, l) => Object.assign(acc, { [l]: (acc[l] || 0) + 1 }), {});
  const letters = Object.keys(freqTable).map(l => [freqTable[l], l]).sort(sorter);

  const validCheckSum = letters.slice(0, 5).map(([f, l]) => l).join('');

  return checkSum === validCheckSum ? sum + parseInt(id) : sum;
}, 0);

console.log(answer);
