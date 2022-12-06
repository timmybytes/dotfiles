#!/usr/bin/env node
//title          :filesearch.js
//description    :Search a file for a phrase or phrases
//author         :Timothy Merritt
//date           :2022-12-05
//version        :0.1.0
//usage          :./filesearch.sh
//notes          :
//bash_version   :5.2.12(1)-release
//============================================================================

const fs = require("fs");
const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

function fileSearch() {
  const files = fs.readdirSync(".");

  // Print the list of files to the console
  console.log("Files in the current directory:");
  files.forEach((file) => console.log(file));

  // Prompt the user to choose one of the available files
  rl.question("Enter the name of a file to choose: ", (fileName) => {
    console.log(`You chose: ${fileName}`);

    // Store the user's choice in a variable
    const chosenFile = fileName;

    // Read the file content
    const content = fs.readFileSync(chosenFile, "utf-8");

    // Split the file content into an array of lines
    const lines = content.split("\n");

    // Prompt the user for the phrase(s) to search for
    rl.question(
      "Enter the phrase(s) to search for (comma-delimited): ",
      (searchPhrases) => {
        // Split the search phrases into an array
        const searchPhraseList = searchPhrases
          .split(",")
          .map((phrase) => phrase.trim());

        // Create an object to store the search results
        const searchResults = {};

        // Search each line for each search phrase
        lines.forEach((line, lineNumber) => {
          searchPhraseList.forEach((searchPhrase) => {
            // Use a regular expression to search for the search phrase
            const regex = new RegExp(searchPhrase, "gi");
            const matches = line.match(regex);

            // If there are any matches, add them to the search results object
            if (matches) {
              searchResults[lineNumber] = {
                line: line,
                matches: matches,
              };
            }
          });
        });

        // Print the search results to the console
        console.log("Search results:");
        Object.keys(searchResults).forEach((lineNumber) => {
          const { line, matches } = searchResults[lineNumber];
          console.log(
            `Line ${lineNumber}: ${line} (${matches.length} matches)`
          );
        });
        rl.close();
      }
    );
  });
}

fileSearch();
