#!/bin/bash

# Install twin.macro, Emotion, and babel-plugin-macros
yarn add twin.macro @emotion/react @emotion/styled babel-plugin-macros

# Create .babelrc if it doesn't exist, and configure it
if [ ! -f .babelrc ]; then
  echo '{
  "plugins": ["babel-plugin-macros"]
}' >.babelrc
fi

# Create twin.config.js and configure it for Emotion
echo "module.exports = {
  twin: {
    preset: 'emotion',
  },
};" >twin.config.js

# If using TypeScript, install the TypeScript plugin for Emotion
if [ -f tsconfig.json ]; then
  yarn add -D @emotion/eslint-plugin

  # If .eslintrc.js exists, add the @emotion plugin and rule
  if [ -f .eslintrc.js ]; then
    npx json -I -f .eslintrc.js -e "this.plugins=this.plugins||[];this.plugins.push('@emotion')"
    npx json -I -f .eslintrc.js -e "this.rules=this.rules||{};this.rules['@emotion/jsx-import']='error'"
  fi
fi

echo "twin.macro setup complete."
