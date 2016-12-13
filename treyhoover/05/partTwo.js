const md5 = require('md5');
const colors = require('colors');

const hash = (id) => (index) => md5(id + index);
const hashIndex = hash('ffykfhsq');
const isValidHash = (hash) => hash.slice(0, 5) === '00000';
const possibleChars = 'abcdefghijklmnopqrstuvwxyz0123456789'; // sometimes fun > performance

let password = new Array(8);
let cracked = false;
let i = 0;

const randomChar = () => colors.red(possibleChars[Math.floor(Math.random() * possibleChars.length)]);

const getPassword = () => {
  const actual = password.join('');

  if (actual.length === 8) return actual;

  let inProgress = '';

  for (let i = 0; i < 8; i++) {
    const actual = password[i];
    inProgress += (actual ? colors.green(actual) : randomChar()) + ' ';
  }

  return inProgress;
};

while (!cracked) {
  const hash = hashIndex(i++);
  const valid = isValidHash(hash);

  if (valid) {
    const pos = Number(hash.charAt(5));
    const char = hash.charAt(6);
    if (pos > 7 || isNaN(pos) || password[pos]) continue;

    password[pos] = char;

    cracked = password.join('').length === 8;

  } else if (i % 3000 === 0) {
    process.stdout.clearLine();
    process.stdout.cursorTo(0);
    process.stdout.write(getPassword());
  }
}

process.stdout.clearLine();
process.stdout.cursorTo(0);
console.log(colors.green(password.join('')));