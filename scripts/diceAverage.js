// usage: node diceAverage.js [dice notation with modifier]
// The expected input format is "XdY+Z" or "XdY-Z" where:
const diceInput = process.argv[2];

if (!diceInput) {
  console.error(
    'Please provide a valid dice notation with modifier (e.g., "3d6+4").'
  );
  process.exit(1);
}

const diceMatch = diceInput.match(/(\d+d\d+)([+-]\d+)?/);
const diceNotation = diceMatch[1];
const modifier = diceMatch[2] || "+0";
if (!/^\d+d\d+$/.test(diceNotation)) {
  console.error(
    'Invalid dice notation. Please use a format like "3d6+4" or "3d6 - 4".'
  );
  process.exit(1);
}

const [numberOfDice, numberOfFaces] = diceNotation.split("d").map(Number);
const modifierValue = parseInt(modifier, 10) || 0;

if (
  isNaN(numberOfDice) ||
  isNaN(numberOfFaces) ||
  numberOfDice < 1 ||
  numberOfFaces < 1
) {
  console.error(
    'Invalid dice notation. Please use a format like "3d6+4" or "3d6 - 4".'
  );
  process.exit(1);
}

function calculateAverageRoll(numberOfDice, numberOfFaces) {
  return ((numberOfFaces + 1) / 2) * numberOfDice;
}
const averageRoll = calculateAverageRoll(numberOfDice, numberOfFaces);
console.log(
  `The average roll of ${numberOfDice}d${numberOfFaces} ${modifier} is ${
    averageRoll + (modifier.startsWith("-") ? -modifierValue : modifierValue)
  }.`
);
