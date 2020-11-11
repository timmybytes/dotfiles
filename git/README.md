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

```sh
# Commit messages should loosely follow the following conventions:

# Header - mandatory
(type): Short description
^....^: ^...............^
│       * Less than 60 characters
│       * Present tense
│       * Concise
│
└── Contains one of the following:
    * feat        A new feature
    * fix         A bug fix
    * docs        Changes to documentation only
    * style       Style/format changes (whitespace, etc.)
    * refactor    Changes not related to a bug or feature
    * perf        Changes that affects performance
    * test        Changes that add/modify/correct tests
    * build       Changes to build system (configs, etc.)
    * ci          Changes to CI pipeline/workflow

# Body - optional
Introduces motivation behind changes and/or more detailed information

# Footer - optional
Consequences of the change(s), such as related issues resolved by commit, etc.

```
