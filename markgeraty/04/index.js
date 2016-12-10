var fs = require('fs');

function parseLine(line) {
  if (line === "") return 0;
  const leftBracket = line.indexOf('[');
  const checksum = line.substring(leftBracket+1, line.length - 1);
  const sectorId = line.match(/\d+/)[0];
  const characters = line.substring(0, leftBracket)
    .replace(/-/g, "").replace(/\d/g, "")
    .split("")
    .reduce(function(acc, next) {
      if (acc[next]) acc[next]++;
      else acc[next] = 1;

      return acc;
    }, {});
  const sortedCharacters = Object.keys(characters).sort(function(l, r) {
    if (characters[l] === characters[r]) {
      return l.charCodeAt(0) - r.charCodeAt(0);
    } else {
      return characters[r] - characters[l];
    }
  });

  const topFive = sortedCharacters.slice(0,5).join("");

  const valid = topFive === checksum;

  if (valid) {
    const rotation = Number(sectorId) % 26;
    const encrypted = line.substring(0, leftBracket).replace(/\d/g, "").split("");
    const decrypted = encrypted.map(function(character) {
      let code = character.charCodeAt(0);
      if (code === 45) return " ";
      for (var i = 0; i < rotation; i++) {
        code++;
        if (code > 122) code = 97;
      }

      return String.fromCharCode(code);
    }).join("");

    // console.log(decrypted);

    if (decrypted.indexOf('north') > -1) {
      console.log(decrypted, line);
    }
  }

  return (valid ? Number(sectorId) : 0);
}

fs.readFile('./input.txt', 'utf8', function(error, data) {
  console.log(data.split('\n').map(parseLine).reduce((acc, next) => acc + next, 0));
});
