#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: ./create_project.sh <project_name> <framework>"
  exit 1
fi

PROJECT_NAME=$1
FRAMEWORK=$2

if [ -d "$PROJECT_NAME" ]; then
  echo "Error: Directory '$PROJECT_NAME' already exists."
  exit 1
fi

if [ "$FRAMEWORK" != "next" ] && [ "$FRAMEWORK" != "vite" ]; then
  echo "Invalid framework. Choose either 'next' or 'vite'"
  exit 1
fi

create_project() {
  if [ "$FRAMEWORK" == "next" ]; then
    yarn create next-app --example with-typescript "$PROJECT_NAME"
  else
    yarn create @vitejs/app "$PROJECT_NAME" --template react-ts
  fi
}

install_dependencies() {
  cd "$PROJECT_NAME" || exit
  yarn add eslint prettier plop framer-motion twin.macro husky lint-staged jest chalk @testing-library/react @types/jest @types/react @types/react-dom eslint-config-prettier eslint-plugin-react eslint-plugin-react-hooks @typescript-eslint/parser @typescript-eslint/eslint-plugin -D
}

create_folders() {
  mkdir -p src/components/atoms src/components/molecules/.gitkeep src/components/organisms/.gitkeep src/components/wrappers/.gitkeep
}

create_configs() {
  cat >.eslintrc.json <<EOL
module.exports = {
  env: {
    browser: true,
    es2021: true,
  },
  // Patch in node globals since we use the browser env,
  // for this file, scripts, etc.
  globals: {
    module: true,
    require: true,
    process: true,
    jest: true,
  },
  extends: [
    'plugin:react/recommended',
    'plugin:react/jsx-runtime',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
    'plugin:storybook/recommended',
    'next/core-web-vitals',
  ],
  ignorePatterns: [
    'node_modules/**/*',
    'public/**/*',
    'static/**/*',
    '.cache/**/*',
    '.next/**/*',
    '.netlify/**/*',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 12,
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint', 'react', 'react-hooks', 'jsx-a11y'],
  rules: {
    'no-console': [
      'warn',
      {
        allow: ['info', 'warn', 'error', 'debug'],
      },
    ],
    'no-prototype-builtins': 'off',
    'react/prop-types': 'off',
    'react/no-unescaped-entities': 'off',
    'react/no-unused-expressions': 'off',
    '@typescript-eslint/no-explicit-any': ['warn'],
    // These two settings are used together to prevent eslint from warning on types
    'no-unused-vars': 'off',
    '@typescript-eslint/no-unused-vars': [
      'warn',
      {
        args: 'none',
      },
    ],
  },
  settings: {
    react: {
      version: 'detect',
    },
  },
};

EOL

  cat >.prettierrc <<EOL
{
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 100
}
EOL

  cat >.lintstagedrc.json <<EOL
{
  "*.{js,jsx,ts,tsx}": ["eslint --fix", "prettier --write", "git add"]
}
EOL

  cat >.huskyrc.json <<EOL
{
  "hooks": {
    "pre-commit": "lint-staged"
  }
}
EOL

  cat >jest.config.js <<EOL
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx'],
  testPathIgnorePatterns: ['/node_modules/'],
  transformIgnorePatterns: ['/node_modules/'],
  moduleNameMapper: {
    '\\.(css|less|scss)$': 'identity-obj-proxy',
  },
};
EOL

  cat >.gitignore <<EOL
node_modules
.next
out
dist
.cache
EOL

  cat >README.md <<EOL
# $PROJECT_NAME

This project was created using the custom script \`create_project.sh\`.

## Setup

1. Install dependencies:

\`\`\`
yarn install
\`\`\`

2. Run the development server:

\`\`\`
yarn dev
\`\`\`

3. To generate Atomic components, use the following command:

\`\`\`
yarn plop component
\`\`\

4. Run tests:

yarn test

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
EOL

  cat >LICENSE <<EOL
MIT License

Copyright (c) $(date +%Y) <Your Name>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOL

  mkdir -p .github/workflows
  cat >.github/workflows/lighthouse.yml <<EOL
name: Lighthouse

on:
  push:
    branches:
      - main

jobs:
  lighthouse:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Setup Node.js
      uses: actions/setup-node@v2
      with:
        node-version: 14

    - name: Install dependencies
      run: yarn install

    - name: Build project
      run: yarn build

    - name: Run Lighthouse
      run: |
        yarn global add lighthouse
        lighthouse http://localhost:3000 --output=json --output=html --output-path=./lighthouse
      env:
        CI: true

    - name: Upload artifacts
      uses: actions/upload-artifact@v2
      with:
        name: lighthouse-results
        path: ./lighthouse
EOL

  cat >plopfile.mjs <<EOL
import { resolve } from 'path';
export default (plop) => {
  plop.setPrompt('directory', require('inquirer-directory'));
  plop.setGenerator('component', {
    description: 'Generate an Atomic component',
    prompts: [
      {
        type: 'list',
        name: 'type',
        message: 'Component type:',
        choices: ['atoms', 'molecules', 'organisms', 'templates', 'pages'],
      },
      {
        type: 'input',
        name: 'name',
        message: 'Component name:',
        validate: (value) => {
          if (/.+/.test(value)) {
            return true;
          }
          return 'Component name is required';
        },
      },
    ],
    actions: [
      {
        type: 'add',
        path: 'src/components/{{type}}/{{pascalCase name}}/{{pascalCase name}}.tsx',
        templateFile: resolve(__dirname, 'templates/component.hbs'),
      },
    ],
  });
};
EOL

  mkdir -p templates
  cat >templates/component.hbs <<EOL
import tw from 'twin.macro';
import React from 'react';

const {{pascalCase name}}Container = tw.div\`bg-gray-100\`;
const {{pascalCase name}} = () => {
return (
<{{pascalCase name}}Container>
<p>{{pascalCase name}} component</p>
</{{pascalCase name}}Container>
);
};

export default {{pascalCase name}};
EOL

  cat >tailwind.config.js <<EOL

module.exports = {
purge: [],
darkMode: false,
theme: {
extend: {
backgroundColor: {
'primary': '#161925',
'secondary': '#e9c46a',
},
textColor: {
'primary': '#161925',
'secondary': '#e9c46a',
},
},
},
variants: {
extend: {},
},
plugins: [],
};
EOL

}

create_project
install_dependencies
create_folders
create_configs
