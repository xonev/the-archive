# Create a file called ".enivronment.sh" (which is ignored by git) in order to set up enviroment settings
env_file=~/.environment.sh
if [[ -e "$env_file" ]]; then
    echo "Sourcing $env_file"
    source "$env_file"
fi

homebrew_dir="$(brew --prefix)"

# NVM is installed via homebrew. This loads it and sets it up
export NVM_DIR="$HOME/.nvm"
[ -s "/$homebrew_dir/opt/nvm/nvm.sh" ] && . "$homebrew_dir/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/$homebrew_dir/opt/nvm/etc/bash_completion" ] && . "/$homebrew_dir/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

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

if [[ ($IS_SEEQ_HARDWARE) ]]; then
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

# Set this up for StevenOxley.com. It can be removed once StevenOxley.com is updated
eval "$(rbenv init -)"

# Set up GraalVM
export GRAALVM_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-lts-java11-20.3.1/Contents/Home

# fzf oh-my-zsh plugin settings: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fzf
FZF_BASE="${homebrew_dir}/bin/fzf"
export FZF_BASE

# antigen and oh-my-zsh settings
source "$homebrew_dir"/share/antigen/antigen.zsh

# Load the oh-my-zsh library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle vi-mode
antigen bundle fzf

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
antigen theme geometry-zsh/geometry

# Tell Antigen that you're done.
antigen apply

# vi-mode settings
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

# Terraform autocomplete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

source ~/secrets/teamcity.zsh

# All path manipulations go here for easier understanding of ordering, etc.
# Bin path ordering is important
eval "$($homebrew_dir/bin/brew shellenv)"
PATH=/opt/local/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$GRAALVM_HOME/bin:$PATH
export PATH="$homebrew_dir/opt/terraform@0.12/bin:$PATH"

if [[ -f ~/.creds/seeq_creds.sh ]]; then
    source ~/.creds/seeq_creds.sh
fi

# According to this page gcloud doesn't support Python 3.10:
# This line can be removed when it does
export CLOUDSDK_PYTHON="/usr/local/bin/python3.9"

mkdir -p ~/log/tmux
