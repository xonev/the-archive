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
eval $(ssh-agent)
