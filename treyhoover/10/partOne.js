const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8');

const bots = {};
const output = {};

const lines = input.split('\n');

class Bot {
  constructor(id, values = []) {
    this.id = id;
    this.values = values;
    this.lowTarget = {
      type: null,
      id: null
    };

    this.highTarget = {
      type: null,
      id: null
    };

    this.check = this.check.bind(this);
  }

  transferLow(value) {
    const { type, id } = this.lowTarget;

    if (type === 'output') {
      output[id] = value;
    } else if (bots[id]) {
      bots[id].add(value);
    }
  }

  transferHigh(value) {
    const { type, id } = this.highTarget;

    if (type === 'output') {
      output[id] = value;
    } else if (bots[id]) {
      bots[id].add(value)
    }
  }

  add(value) {
    this.values = this.values.concat(parseInt(value));
    this.check();
  }

  check() {
    if (this.values.length === 2) {
      const [low, high] = this.values.sort((a, b) => a - b);

      this.transferLow(low);
      this.transferHigh(high);
      this.values = [];

      console.log(`bot ${this.id} compares ${low} and ${high}`);
    }
  }
}

lines.forEach(line => {
  const input = line.match(/value (\d+) goes to bot (\d+)/);
  const instruction = line.match(/bot (\d+) gives low to (output|bot) (\d+) and high to (output|bot) (\d+)/);

  if (input) {
    const [, value, botId] = input;

    if (bots[botId]) {
      bots[botId].values = bots[botId].values.concat(parseInt(value));
    } else {
      bots[botId] = new Bot(botId, [parseInt(value)]);
    }
  } else if (instruction) {
    const [, botId, lowTargetType, lowTargetId, highTargetType, highTargetId] = instruction;

    if (!bots[botId]) bots[botId] = new Bot(botId);

    const bot = bots[botId];

    bot.lowTarget.type = lowTargetType;
    bot.lowTarget.id = lowTargetId;

    bot.highTarget.type = highTargetType;
    bot.highTarget.id = highTargetId;
  }
});

Object.keys(bots).forEach(id => {
  const bot = bots[id];

  if (bot.values.length == 2) {
    console.log(`bot ${id} starts with 2`);
    bot.check();
  }
});

// console.log(bots);
// console.log(output);
