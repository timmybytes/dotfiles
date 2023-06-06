// usage: node diceAverage.js [dice notation with modifier]

const input = process.argv[2];

if (!input) {
  console.error(
    'Please provide a valid dice notation with modifier (e.g., "3d6+4").'
  );
  process.exit(1);
}

const [diceNotation, modifier] = input
  .split(/([+-])/)
  .map((item) => item.trim());
const [numberOfDice, numberOfFaces] = diceNotation.split("d").map(Number);
const modifierValue = parseInt(modifier, 10) || 0;

if (isNaN(numberOfDice) || isNaN(numberOfFaces) || numberOfFaces < 1) {
  console.error(
    'Invalid dice notation. Please use a format like "3d6+4" or "3d6 - 4".'
  );
  process.exit(1);
}

const averageRoll = ((numberOfFaces + 1) / 2) * numberOfDice;

if (input.includes("-")) {
  console.log(
    `The average roll of ${numberOfDice}d${numberOfFaces} - ${modifierValue} is ${
      averageRoll - modifierValue
    }.`
  );
} else {
  console.log(
    `The average roll of ${numberOfDice}d${numberOfFaces} + ${modifierValue} is ${
      averageRoll + modifierValue
    }.`
  );
}
