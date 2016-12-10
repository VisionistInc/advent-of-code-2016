const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');
const ALPHABET = 'abcdefghijklmnopqrstuvwxyz'.split('');

const sorter = ([freqA, a], [freqB, b]) => freqA === freqB ? a.charCodeAt(0) - b.charCodeAt(0) : freqB - freqA;

const shift = (name, n) => {
  return name.split('').map(l => {
    if (l === '-') return ' '; // dashes stay the same

    const index = ALPHABET.findIndex(a => a === l);
    if (index < 0) return l; // don't shift chars not in our alphabet

    return ALPHABET[(index + n) % ALPHABET.length];
  }).join('');
};

const rooms = input.split('\n').reduce((validRooms, line) => {
  const [, name, id, checkSum] = line.match(/([\w-]+)-(\d+)\[(\w+)\]/);
  const freqTable = name.match(/([a-zA-Z])/g).reduce((acc, l) => Object.assign(acc, { [l]: (acc[l] || 0) + 1 }), {});
  const letters = Object.keys(freqTable).map(l => [freqTable[l], l]).sort(sorter);

  const validCheckSum = letters.slice(0, 5).map(([f, l]) => l).join('');

  const decodedName = shift(name, parseInt(id));

  return checkSum === validCheckSum ? validRooms + `${decodedName}, ${id}\n` : validRooms;
}, '');

fs.writeFile('output.txt', rooms);