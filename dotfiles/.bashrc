# When debating between .bash_profile and .bashrc:
# http://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile

# Bin path ordering is important
PATH=/opt/local/bin:/usr/local/bin:/usr/local/sbin:$PATH

# NVM is installed via homebrew. This loads it and sets it up
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

shopt -s histappend

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1="\h:\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\]$ "
export WORKTREE_INITIALS=sajo
export WORKTREE_DIRECTORY_PREFIX=/Users/soxley/workspace/seeq/crab
export WORKTREE_DEVELOP_SESSION=develop

alias tm="~/.tmux/tmux.sh"
alias grep="grep --color=auto"
alias sftp='with-readline sftp'
alias worktree='/Users/soxley/scripts/worktree.sh'

set -o vi

# Quick and dirty case-insensitive filtered history command.
# "hist" ==> "history"
# "hist foo" ==> "history | grep -i foo"
# "hist foo bar" ==> "history | grep -i foo | grep -i bar"
# etc.
# Note that quotes are ignored, e.g.
#   <<<hist "foo bar">>> is equivalent to <<<hist foo bar>>>
hist()
{
   HISTORYCMD="history $@"             # "foo bar" ==> "history foo bar"
   HISTORYCMD="${HISTORYCMD% }"        # "history " ==> "history" (no trailing space)
   eval "${HISTORYCMD// / | grep -i }" # "history foo bar" ==>
                                       #   "history | grep -i foo | grep -i bar"
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

# TeamCity access token for Seeq (used by the sq ship command)
export TEAMCITY_ACCESS_TOKEN=eyJ0eXAiOiAiVENWMiJ9.RmI0SXlXd3E2OTZjT29id3kxMk5maFlWOEdr.OWUyMmQ3M2QtZjJlZC00ZDNiLThmNzctY2NlMmM4ZWVlZjk1
. "$HOME/.cargo/env"
