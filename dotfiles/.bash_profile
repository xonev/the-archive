# When debating between .bash_profile and .bashrc:
# http://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile
# .bash_profile is run when bash is the login shell. .basrc is run in other cases.
# Only include stuff that should be visible on login in here. We'll source .bashrc here
# and include all of the other config in .bashrc.
. "$HOME/.bashrc"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

