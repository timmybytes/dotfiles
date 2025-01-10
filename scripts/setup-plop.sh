#!/usr/bin/env bash
#
# setup-plop.sh
# A script to install Plop.js, create basic templates, and add generate scripts.
#

# --- 1. Check/Install plop and chalk as dev dependencies ---

echo "Checking for 'plop' and 'chalk' in devDependencies..."
if ! grep -q '"plop"' package.json || ! grep -q '"chalk"' package.json; then
  echo "One or both missing. Installing plop and chalk as dev dependencies..."
  yarn add -D plop chalk
else
  echo "'plop' and 'chalk' found in devDependencies. Skipping install."
fi

# --- 2. Create templates directory structure ---

echo "Creating template directories..."
mkdir -p src/templates/plop/Component
mkdir -p src/templates/plop/Context
mkdir -p src/templates/plop/Hook
mkdir -p src/templates/plop/Page

# --- 3. Populate template files ---

# Component.tsx.hbs
cat <<'EOF' >src/templates/plop/Component/Component.tsx.hbs
{{!-- Component.tsx.hbs  --}}

import { FC } from 'react';
import tw from 'twin.macro';
import { CustomCssProps } from '~/types';

export type {{pascalCase name}}Props = CustomCssProps & {
  //
};

/**
 * {{pascalCase name}}
 */
export const {{pascalCase name}}: FC<{{pascalCase name}}Props> = ({
  customCss
  }) => {
  return (
    <Container css={customCss}>Hello!</Container>
  );
};

const Container = tw.div``;
EOF

# Context.tsx.hbs
cat <<'EOF' >src/templates/plop/Context/Context.tsx.hbs
{{!-- Context.tsx.hbs  --}}
import { createContext, FC, useContext } from 'react';

type {{pascalCase name}}Value = Record<string, any>;

const {{pascalCase name}} =  createContext<{{pascalCase name}}Value>({});;

const {{pascalCase name}}Provider: FC = ({ children }) => {
  const context: {{pascalCase name}}Value = {};

  return (
    <{{pascalCase name}}.Provider value={context}>{children}</{{pascalCase name}}.Provider>
  );
};

const use{{pascalCase name}} = (): {{pascalCase name}}Value => {
  const {{camelCase name}}Ctx = useContext({{pascalCase name}});
  return {{camelCase name}}Ctx;
};

export { {{pascalCase name}}, {{pascalCase name}}Provider, use{{pascalCase name}} };
EOF

# Hook.ts.hbs
cat <<'EOF' >src/templates/plop/Hook/Hook.ts.hbs
{{!-- Hook.ts.hbs  --}}

import { useEffect, useState } from 'react';

/**
 * {{camelCase name}}
 * Hook
 */
export function {{camelCase name}}() {
  const [data, setData] = useState(false);

  useEffect(() => {
    setData(!data);
  }, [data]);

  return data;
}
EOF

# Page.tsx.hbs
cat <<'EOF' >src/templates/plop/Page/Page.tsx.hbs
import { FC } from 'react';

interface {{pascalCase name}}Props {
  //
}

export const {{pascalCase name}}: FC<{{pascalCase name}}Props> = () => {
  return (
    <div>
      <h1>{{pascalCase name}}</h1>
      <p>This is a new page!</p>
    </div>
  );
};
EOF

# index.ts.hbs
cat <<'EOF' >src/templates/plop/index.ts.hbs
{{!-- index.ts.hbs  --}}

export * from './{{pascalCase name}}';
EOF

echo "Template files created!"

# --- 4. Create plopfile.mjs ---

cat <<'EOF' >plopfile.mjs
// plopfile.mjs

import chalk from 'chalk'
// Templates
const TEMPLATES_DIR = 'src/templates/plop'
const INDEX = `${TEMPLATES_DIR}/index.ts.hbs`
const COMPONENT = `${TEMPLATES_DIR}/Component/Component.tsx.hbs`
const HOOK = `${TEMPLATES_DIR}/Hook/Hook.ts.hbs`
const CONTEXT = `${TEMPLATES_DIR}/Context/Context.tsx.hbs`
const PAGE = `${TEMPLATES_DIR}/Page/Page.tsx.hbs`

/**
 * Plop configuration for automating file generation
 * Create generators and user prompts to populate the data object
 * (properties can be manually added to data as well).
 * Pass data to actions to generate files.
 *
 * See more at https://plopjs.com/documentation
 * @param {*} plop
 */
export default plop => {
  plop.setWelcomeMessage('Choose from the options below:')

  // Component generator
  plop.setGenerator('component', {
    description: 'Create a new atomic component',
    prompts: [
      {
        type: 'list',
        name: 'heirarchy',
        message: 'Select a type:',
        choices: [
          {
            name: 'Atom',
            value: 'atoms',
          },
          {
            name: 'Molecule',
            value: 'molecules',
          },
          {
            name: 'Organism',
            value: 'organisms',
          },
          {
            name: 'Wrapper',
            value: 'wrappers',
          },
        ],
      },
      {
        type: 'input',
        name: 'name',
        message: 'Enter a name for the component:',
      },
    ],
    actions: data => {
      if (!data.name) {
        data.name = `${data.heirarchy.slice(0, -1)}${Date.now().toString()}`
        console.log(
          chalk.yellowBright(
            `No Component name given. Creating randomized naming...`,
          ),
        )
        console.log(chalk.greenBright(`Created ${data.name}`))
      }

      let actions = []

      // Create subdirectory structure
      if (data.name.includes('/')) {
        data.subDirPath = data.name.split('/')[0]
        data.name = data.name.split('/')[1]
        actions.push(
          {
            type: 'add',
            path: 'src/components/{{heirarchy}}/{{subDirPath}}/{{pascalCase name}}/{{pascalCase name}}.tsx',
            templateFile: COMPONENT,
          },
          {
            type: 'add',
            path: 'src/components/{{heirarchy}}/{{subDirPath}}/{{pascalCase name}}/index.ts',
            templateFile: INDEX,
          },
          {
            type: 'add',
            path: 'src/components/{{heirarchy}}/{{subDirPath}}/index.ts',
            skipIfExists: true,
          },
          {
            type: 'append',
            path: 'src/components/{{heirarchy}}/{{subDirPath}}/index.ts',
            template: "export * from './{{pascalCase name}}'",
          },
        )
        // Add new wrapper to wrappers/index.ts exports
        if (data.heirarchy === 'wrappers') {
          actions.push({
            type: 'append',
            path: 'src/components/wrappers/index.ts',
            template: "export * from './{{subDirPath}}/{{pascalCase name}}'",
          })
        }
      } else {
        actions.push(
          {
            type: 'add',
            path: 'src/components/{{heirarchy}}/{{pascalCase name}}/{{pascalCase name}}.tsx',
            templateFile: COMPONENT,
          },
          {
            type: 'add',
            path: 'src/components/{{heirarchy}}/{{pascalCase name}}/index.ts',
            templateFile: INDEX,
          },
        )
        // Add new wrapper to wrappers/index.ts exports
        if (data.heirarchy === 'wrappers') {
          actions.push({
            type: 'append',
            path: 'src/components/wrappers/index.ts',
            template: "export * from './{{pascalCase name}}'",
          })
        }
      }

      return actions
    },
  })

  // Hook generator
  plop.setGenerator('hook', {
    description: 'Create a new hook',
    prompts: [
      {
        type: 'input',
        name: 'name',
        message: 'Enter a name for the hook:',
      },
    ],
    actions: data => {
      if (!data.name) {
        data.name = `useHook${Date.now().toString()}`
        console.log(
          chalk.yellowBright(
            `No Hook name given. Creating randomized naming...`,
          ),
        )
        console.log(chalk.greenBright(`Created ${data.name}`))
      }

      if (
        !data.name.startsWith('use') ||
        data.name[3] != data.name[3].toUpperCase()
      ) {
        throw new Error(
          chalk.bgRedBright(
            `"${data.name}" does not follow React Hook naming conventions, e.g., "useName"`,
          ),
        )
      }

      let actions = []
      actions.push(
        {
          type: 'add',
          path: 'src/hooks/{{camelCase name}}.ts',
          templateFile: HOOK,
        },
        {
          // Add new hook to hooks/index.ts exports
          type: 'append',
          path: 'src/hooks/index.ts',
          template: "export * from './{{camelCase name}}'",
        },
      )
      return actions
    },
  })

  // Context generator
  plop.setGenerator('context', {
    description: 'Create a new React context ',
    prompts: [
      {
        type: 'input',
        name: 'name',
        message: 'Enter a name for the Context:',
      },
    ],
    actions: data => {
      if (!data.name) {
        data.name = `Misc${Date.now().toString()}Context`
        console.log(
          chalk.yellowBright(
            `No Context name given. Creating randomized naming...`,
          ),
        )
        console.log(chalk.greenBright(`Created ${data.name}`))
      }

      if (!data.name.includes('Context')) {
        throw new Error(
          chalk.bgRedBright(
            `"${data.name}" does not follow React Context naming conventions, e.g., "NameContext"`,
          ),
        )
      }

      let actions = []
      actions.push({
        type: 'add',
        path: 'src/context/{{titleCase name}}.tsx',
        templateFile: CONTEXT,
      })
      return actions
    },
  })

  // Page generator
  plop.setGenerator('page', {
    description: 'Create a new Page component',
    prompts: [
      {
        type: 'input',
        name: 'name',
        message: 'Enter a name for the Page:',
      },
    ],
    actions: data => {
      if (!data.name) {
        data.name = `Page${Date.now().toString()}`
        console.log(
          chalk.yellowBright(
            `No Page name given. Creating randomized naming...`,
          ),
        )
        console.log(chalk.greenBright(`Created ${data.name}`))
      }

      let actions = []
      actions.push(
        {
          type: 'add',
          path: 'src/pages/{{pascalCase name}}.tsx',
          templateFile: PAGE,
        }
      )
      return actions
    },
  })
}
EOF

echo "plopfile.mjs created!"

# --- 5. Safely update package.json to add scripts ---

echo "Updating package.json with plop scripts..."

node -e "
  const fs = require('fs');
  const path = 'package.json';
  const pkg = JSON.parse(fs.readFileSync(path, 'utf-8'));

  pkg.scripts = pkg.scripts || {};

  // Only add if they don't already exist
  if (!pkg.scripts.generate) {
    pkg.scripts.generate = 'yarn plop';
  }
  if (!pkg.scripts.atom) {
    pkg.scripts.atom = 'yarn plop component atom';
  }
  if (!pkg.scripts.molecule) {
    pkg.scripts.molecule = 'yarn plop component molecule';
  }
  if (!pkg.scripts.organism) {
    pkg.scripts.organism = 'yarn plop component organism';
  }
  if (!pkg.scripts.wrapper) {
    pkg.scripts.wrapper = 'yarn plop component wrapper';
  }
  if (!pkg.scripts.hook) {
    pkg.scripts.hook = 'yarn plop hook';
  }
  if (!pkg.scripts.context) {
    pkg.scripts.context = 'yarn plop context';
  }
  if (!pkg.scripts.page) {
    pkg.scripts.page = 'yarn plop page';
  }

  fs.writeFileSync(path, JSON.stringify(pkg, null, 2));
"

echo "Done! Now you can run 'yarn generate' or any specialized script (e.g., 'yarn hook') to create files using plop."
