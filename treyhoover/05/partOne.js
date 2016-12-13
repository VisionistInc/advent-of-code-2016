const md5 = require('./md5');

const hash = (id) => (index) => md5(id + index);
const hashIndex = hash('ffykfhsq');
const isValidHash = (hash) => hash.slice(0, 5) === '00000';

let password = '';
let i = 0;

while (password.length < 8) {
  const hash = hashIndex(i++);
  const valid = isValidHash(hash);

  if (valid) {
    password += hash.charAt(5);
    console.log(password);
  }
}

console.log('password:', password);