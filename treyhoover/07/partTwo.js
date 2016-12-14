const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');

const lines = input.split('\n');

const isAbba = (str) => str[0] === str[2] && str[0] !== str[1];

const getAbas = str => {
  const abas = [];

  for (let i = 3; i <= str.length; i++) {
    const slice = str.slice(i - 3, i);
    if (isAbba(slice)) abas.push(slice);
  }

  return abas;
};

const getMirror = str => str[1] + str[0] + str[1];

const containsMirror = (hypernets, supernets) => {
  for (let supernet of supernets) {
    if (hypernets.includes(getMirror(supernet))) return true;
  }

  return false;
};

const answer = lines.map(line => {
  return line.match(/\[?\w+]?/g).reduce((acc, g) => {
    if (g[0] === '[') {
      acc.hypernets = acc.hypernets.concat(getAbas(g.slice(1, -1)));
    } else {
      acc.supernets = acc.supernets.concat(getAbas(g));
    }

    return acc;
  }, { hypernets: [], supernets: [] });
}).reduce((sum, { hypernets, supernets }) => {
  return containsMirror(hypernets, supernets) ? sum + 1 : sum;
}, 0);

console.log(answer);