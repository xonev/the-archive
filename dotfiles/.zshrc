# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="awesomepanda"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

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
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode fzf aws azure aws zsh-autosuggestions)

homebrew_dir="$(brew --prefix)"
# fzf oh-my-zsh plugin settings: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fzf
FZF_BASE="${homebrew_dir}/bin/fzf"
export FZF_BASE

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Create a file called ".enivronment.sh" (which is ignored by git) in order to set up enviroment settings
# This is a good place to set variables like HARDWARE
env_file=~/.environment.sh
if [[ -e "$env_file" ]]; then
    echo "Sourcing $env_file"
    source "$env_file"
fi


# NVM is installed via homebrew. This loads it and sets it up
export NVM_DIR="$HOME/.nvm"
[ -s "/$homebrew_dir/opt/nvm/nvm.sh" ] && . "$homebrew_dir/opt/nvm/nvm.sh"  # This loads nvm

autoload -U add-zsh-hook
load-nvmrc() {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

        if [ "$nvmrc_node_version" = "N/A" ]; then
            nvm install
        elif [ "$nvmrc_node_version" != "$node_version" ]; then
            nvm use
        fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

alias tm="~/.tmux/tmux.sh"
alias grep="grep --color=auto"
alias sftp='with-readline sftp'
alias worktree='/Users/soxley/scripts/worktree.sh'
alias devops_wt='/Users/soxley/scripts/devops_wt.sh'
alias gbc='git branch --merged | egrep -v "(^\*|^\+|main|develop|master)" | xargs git branch -d'
alias gbC='git branch --merged | egrep -v "(^\*|^\+|main|develop|master)" | xargs git branch -D'
alias gld='git log --format="%h | %s [%an]"'
alias sc='npx shadow-cljs'
alias ta=', terragrunt apply'
alias ti=', terragrunt init'
alias t=', terragrunt'

# $HARDWARE can be exported in ~/.environment.sh
if [[ "${HARDWARE-}" == "seeq" ]]; then
    # Seeq customizations
    sq() {
        file=environment
        for i in $(seq 0 $(pwd | tr -cd '/' | wc -c)); do
            if [ -f "$file" ]; then
                break
            fi
            file=../$file
        done
        bash -c 'source '"$file"' && sq "$@"' "$0" "$@"
    }

    spy() {
        file=environment
        for i in $(seq 0 $(pwd | tr -cd '/' | wc -c)); do
            if [ -f "$file" ]; then
                break
            fi
            file=../$file
        done
        bash -c 'source '"$file"' && python -m "$@"' "$0" "$@"
    }

    ,() {
        file=environment
        for i in $(seq 0 $(pwd | tr -cd '/' | wc -c)); do
            if [ -f "$file" ]; then
                break
            fi
            file=../$file
        done
        bash -c 'source '"$file"' && "$@"' "$0" "$@"
    }

    export WORKTREE_INITIALS=sajo
    export WORKTREE_DIRECTORY_PREFIX=/Users/soxley/workspace/seeq/crab
    export WORKTREE_DEVELOP_SESSION=develop

    export DEVOPS_WT_DIRECTORY_PREFIX=/Users/soxley/workspace/seeq/devops
    export DEVOPS_WT_DEVELOP_SESSION=devops

fi


# some node apps require opening a lot of files
ulimit -n 4096

# startup ssh-agent automatically
# I pulled this out of this stackoverflow answer: https://stackoverflow.com/a/18915067/3831
SSH_ENV="$HOME/.ssh/env"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# vi-mode settings
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

source ~/secrets/teamcity.zsh

if [[ -f ~/.creds/creds.sh ]]; then
    source ~/.creds/creds.sh
fi
if [[ -f ~/.creds/seeq_creds.sh ]]; then
    source ~/.creds/seeq_creds.sh
fi

# According to this page gcloud doesn't support Python 3.10:
# This line can be removed when it does
export CLOUDSDK_PYTHON="/usr/local/bin/python3.9"

mkdir -p ~/log/tmux

export LESS="-F -X -R"
PATH="$PATH:$HOME/scripts"
