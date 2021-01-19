# Git

This directory contains my preferred settings and helper functionality for git.
Note these are just _my_ settings, and may break or be incompatible with your own
setup.

## .gitconfig

```sh
[user]
        name = Timothy Merritt
        email = xxx@xxx.xxx
[color]
        ui = auto
[filter "lfs"]
        required = true
        clean = git-lfs clean -- %f
        smudge = git-lfs smudge -- %f
        process = git-lfs filter-process
[init]
        defaultBranch = main
```

## Git Hooks

### Commit Message Conventions

The [commit conventions document](./commit-conventions.txt) serves as a template for git commit messages. For configuation instructions:

> 📖 Read my article on [Keeping Git Commit Messages Consistent with a Custom Template](https://dev.to/timmybytes/keeping-git-commit-messages-consistent-with-a-custom-template-1jkm).

For information on Semantic Versioning conventions, [see the spec](https://semver.org/#semantic-versioning-specification-semver).

#### Commit messages should adhere to the following conventions:

```sh
# Header - mandatory
type(optional scope): Short description
^..................^: ^...............^
│   * Less than 60 characters
│   * Present tense
│   * Concise
│   * Ex: 'docs: correct spelling of CHANGELOG'
│
└── Contains one of the following:
    * feat             A new feature - SemVar PATCH
    └── MUST coincide with 0.0.x patch version
    * fix              A bug fix - SemVar MINOR
    └── MUST coincide with 0.x.0 minor version
    * BREAKING CHANGE  Breaking API change - SemVar MAJOR
    └── MUST coincide with x.0.0 major version, MUST include
        ! before colon e.g., 'BREAKING CHANGE!: message'
    * docs             Change to documentation only
    * style            Change to style (whitespace, etc.)
    * refactor         Change not related to a bug or feat
    * perf             Change that affects performance
    * test             Change that adds/modifies tests
    * build            Change to build system
    * ci               Change to CI pipeline/workflow
    * chore            General tooling/config/min refactor

# Body - optional
Free form structure. Introduces motivation behind changes
and/or more detailed information

# Footer - optional
word-token: string value
          OR
word-token #string value
^.........^: ^.........^
Consequences of the change(s), such as related issues resolved
by commit, etc. 'word-token' must not contain whitespace.

```
