export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/nym/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=6

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git alias-finder autojump wakatime zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

######################################################################
# USER CONFIGURATION
######################################################################

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# --------------------------------------------------------------------
# * ALIASES
# --------------------------------------------------------------------

# ------------------------- * * ZSH * * -----------------------------#
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
# Reload zsh
alias resource="source ~/.zshrc"

# ---------------------- * * SHORTCUTS * * --------------------------#
# Shortcut to custom Firefox CSS
alias userchrome="cd -P /Users/nym/Library/Application\ Support/Firefox/Profiles/p3khxkfo.default-release/chrome"
# Repository Directory
alias repos="cd -P /Users/nym/Projects/#Repos; cv; pwd; t"
# Open coding practice sites in Firefox
alias practice="cd ~/.dotfiles/Scripts/ && ./practice.py"
alias vinit="nvim ~/.config/nvim/init.vim"
alias viminit="nvim ~/.config/nvim/init.vim"
alias jobsearch="cd ~/.dotfiles/scripts/ && ./job_search.py; cd -"

# ------------------------ * * SHELL * * ----------------------------#
# Clear screen
alias cv="clear"
# List simple columns
alias ll="ls -alFC"
# List detailed
alias la="ls -alh"
# Tree list all files one level deep, with summary, sizes, and color
alias t="tree -aFL 1 -s -h -C --du"
# Tree list all files two levels deep, with summary
alias t2="tree -aFL 2 -s -h -C --du"
# Tree list all files three levels deep, with summary
alias t3="tree -aFL 3 -s -h -C --du"
# Tree list all directories only, one level deep, with summary, sizes, and color
alias td="tree -dFL 1 -s -h -C --du"
# Tree list all directories only, two levels deep, with summary, sizes, and color
alias td2="tree -dFL 2 -s -h -C --du"
# Tree list all directories only, three levels deep, with summary, sizes, and color
alias td3="tree -dFL 3 -s -h -C --du"
# Clear screen, then list contents in tree
alias ct="clear; pwd; tree -aFL 1"
# Check files/directories for associated macos tags
alias tags="mdls -raw -name kMDItemUserTags"

# ----------------------- * * CLI TOOLS * * -------------------------#
# Task CLI
# alias tasks="cv; task list; task projects"
eval $(thefuck --alias)
# Use Neovim over vim
alias vim="nvim"
# Prefer VS Code-Insiders over VS Code
alias code="code-insiders"
# Check/delete contents and size of User/System caches
alias cache="clear_caches.sh"
# npm
alias fix="npm audit fix"
# Create new bash script with header template
alias shead="make_header.sh"
# Run OMGWDYD
alias omg="omgwdyd.sh"
# Run upDoc
alias updoc="updoc.sh"
# Run gitchecks on all local repos
alias gitcheckall="gitcheckall.sh"

# ------------------------- * * GIT * * -----------------------------#
alias gs="git status"
alias ga="git add"
alias gap="git add -p"
alias gc="git commit"
alias gmsg="git commit"
alias gac="git add . && git commit -m "
alias gpo="git push origin"
alias gitcheck="mgitstatus -d 1 ."

# ------------------------ * * MACOS * * ----------------------------#
# Quicklook
alias ql="qlmanage -p"
alias short="qlmanage -p /Users/nym/Projects/SystemShortcuts/shortcuts.md"
alias shor-code="qlmanage -p /Users/nym/vs_code_shortcuts.pdf"

# ------------------------ * * RANDOM * * ---------------------------#
# Python
alias py="python3"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Show CLI tools info
alias tools="cat ~/tools"
alias todo="clear; cal; echo; printf "%s\n" "TASKS"; task list"

# --------------------------------------------------------------------
# * TERM & PATH
# --------------------------------------------------------------------
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export TERM="xterm-256color"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin"
export PATH="$PATH:/Users/nym/.dotfiles/scripts"
export PATH="$PATH:/Users/nym/.dotfiles/scripts/OMGWDYD"
export HOMEBREW_NO_AUTO_UPDATE=1

# bear autocomplete setup
BEAR_AC_ZSH_SETUP_PATH=/Users/nym/Library/Caches/@sloansparger/bear/autocomplete/zsh_setup && test -f $BEAR_AC_ZSH_SETUP_PATH && source $BEAR_AC_ZSH_SETUP_PATH

# added for npm-completion https://github.com/Jephuff/npm-bash-completion
PATH_TO_NPM_COMPLETION="/usr/local/lib/node_modules/npm-completion"
source $PATH_TO_NPM_COMPLETION/npm-completion.sh
