var fs = require('fs');

// constants
var directions = { R: 1, L: -1 };
var headings = { N: 0, E: 1, S: 2, W: 3 };

function makeTurn(currentHeading, nextDirection) {
  var nextHeading = currentHeading + directions[nextDirection];

  // wrap if necessary
  if (nextHeading > headings.W) return headings.N;
  else if (nextHeading < headings.N) return headings.W;
  else return nextHeading;
}

function updateCoordinates(currentCoordinates, heading, distance) {
  switch(heading) {
    case headings.N:
      return [currentCoordinates[0], currentCoordinates[1] + distance];
    case headings.E:
      return [currentCoordinates[0] + distance, currentCoordinates[1]];
    case headings.S:
      return [currentCoordinates[0], currentCoordinates[1] - distance];
    case headings.W:
      return [currentCoordinates[0] - distance, currentCoordinates[1]];
    default:
      return currentCoordinates;
  }
}

function calculateTaxicabDistance(coords) {
  return Math.abs(coords[0]) + Math.abs(coords[1]);
}

var input = fs.readFileSync(__dirname + '/input.txt', 'utf8'),
    steps = input.split(", ");

var coordinates = [0,0],
    heading = headings.N;

// for part 2, first location visited twice
var visited = [],
    foundPart2 = false;

// go through each step to calculate final coordinates
steps.forEach(function(nextStep) {
  heading = makeTurn(heading, nextStep[0]);

  // for part 1, can just do:
  // coordinates = updateCoordinates(coordinates, heading, Number(nextStep.substring(1)));

  // for part 2, need to move one unit at a time to record all positions
  var blocksToGo = Number(nextStep.substring(1));
  while(blocksToGo > 0) {
    coordinates = updateCoordinates(coordinates, heading, 1);
    blocksToGo = blocksToGo - 1;

    if (!foundPart2) {
      for(var i = 0; i < visited.length; i++) {
        var oldCoords = visited[i];
        if (oldCoords[0] === coordinates[0] && oldCoords[1] === coordinates[1]) {
          foundPart2 = true;
          break;
        }
      }

      if (foundPart2) {
        console.log("First spot revisited: ", coordinates);
        console.log("Part 2 Distance: ", calculateTaxicabDistance(coordinates));
      } else {
        visited.push(coordinates);
      }
    }
  }
});

console.log('Part 1 Distance: ', calculateTaxicabDistance(coordinates));
