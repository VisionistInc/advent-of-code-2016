const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');

const headings = [
  { label: 'North', axis: 'y', value: 1 },
  { label: 'East', axis: 'x', value: 1 },
  { label: 'South', axis: 'y', value: -1 },
  { label: 'West', axis: 'x', value: -1 }
];

class Player {
  constructor(x = 0, y = 0, headingIdx = 0) {
    this.x = x;
    this.y = y;
    this.headingIdx = headingIdx;

    this.history = {
      [`${this.x}_${this.y}`]: Date.now()
    };
  }

  get location() {
    return { x: this.x, y: this.y };
  }

  get heading() {
    return headings[this.headingIdx];
  }

  get distance() {
    return Math.abs(this.x) + Math.abs(this.y);
  }

  updateHistory() {
    const key = `${this.x}_${this.y}`;

    if (this.history[key]) {
      console.log(`You've been here before!`, this.location, this.distance);
    }

    Object.assign(this.history, { [key]: Date.now() });

    return this;
  }

  moveOne() {
    const { axis, value } = this.heading;
    this[axis] = this[axis] + value;

    this.updateHistory();

    return this;
  }

  move(blocks) {
    for (let i = 0; i < parseInt(blocks); i++) {
      this.moveOne();
    }
  }

  turn(dir) {
    const idx = this.headingIdx;
    const maxIdx = headings.length - 1;

    if (dir === 'L') {
      this.headingIdx = idx === 0 ? maxIdx : idx - 1;
    } else if (dir === 'R') {
      this.headingIdx = idx === maxIdx ? 0 : idx + 1;
    }

    return this;
  }
}

const player = new Player();

const regex = /(\w)(\d+)/g;
let match;

while ((match = regex.exec(input)) !== null) {
  const [, dir, blocks] = match;

  player.turn(dir).move(blocks);
}

console.log(player.distance);