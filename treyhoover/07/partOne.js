const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');

const lines = input.split('\n');

const isAbba = (str) => str[0] === str[3] && str[1] === str[2] && str[0] !== str[1];

const containsAbba = (str) => {
  for (let i = 4; i <= str.length; i++) {
    if (isAbba(str.slice(i - 4, i))) return true;
  }

  return false;
};

const isValid = line => {
  const groups = line.match(/\[?\w+\]?/g);

  return groups.reduce((isValid, group) => {
      if (isValid === -1) return -1;

      const [, hyperNetSeq ] = group.match(/\[(\w+)]/) || [];

      if (hyperNetSeq && containsAbba(hyperNetSeq)) return -1;

      if (isValid === 1) return 1;

      return containsAbba(group) ? 1 : 0;
    }, 0) > 0;
};

const count = lines.reduce((sum, line) => isValid(line) ? sum + 1 : sum, 0);

console.log(count);