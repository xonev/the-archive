# NVM is installed via homebrew. This loads it and sets it up
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

export WORKTREE_INITIALS=sajo
export WORKTREE_DIRECTORY_PREFIX=/Users/soxley/workspace/seeq/crab
export WORKTREE_DEVELOP_SESSION=develop

export DEVOPS_WT_DIRECTORY_PREFIX=/Users/soxley/workspace/seeq/devops
export DEVOPS_DEVELOP_SESSION=devops

alias tm="~/.tmux/tmux.sh"
alias grep="grep --color=auto"
alias sftp='with-readline sftp'
alias worktree='/Users/soxley/scripts/worktree.sh'
alias devops_wt='/Users/soxley/scripts/devops_wt.sh'

# Seeq customizations
sq() {
    set -x
    bash -c 'source environment && sq "$@"' "$0" "$@"
}

spy() {
    set -x
    bash -c 'source environment && python -m "$@"' "$0" "$@"
}

,() {
    file=environment
    for i in $(seq 0 $(pwd | tr -cd '/' | wc -c)); do
        if [ -f "$file" ]; then
            break
        fi
        file=../$file
    done
    set -x
    bash -c 'source '"$file"' && "$@"' "$0" "$@"
}

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

# antigen and oh-my-zsh settings
source /usr/local/share/antigen/antigen.zsh

# Load the oh-my-zsh library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle softmoth/zsh-vim-mode

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme geometry-zsh/geometry

# Tell Antigen that you're done.
antigen apply

# Terraform autocomplete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

source ~/secrets/teamcity.zsh

# All path manipulations go here for easier understanding of ordering, etc.
# Bin path ordering is important
PATH=/opt/local/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$GRAALVM_HOME/bin:$PATH
export PATH="/usr/local/opt/terraform@0.12/bin:$PATH"


source ~/.creds/seeq_creds.sh
