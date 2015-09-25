#!/bin/sh

if [ $# -eq 0 ]; then
  echo attaching to most recent session
  tmux a
else
  if [ "$1" == "ls" ]; then
    tmux_dir=~/.tmux
    ls ~/.tmux/setup_*.sh | sed 's|'"$tmux_dir"'/setup_||' | sed s/.sh//
  else
    echo attaching to or creating: $1
    tmux a -t $1 \
      || [ -f "~/.tmux/setup_$1.sh" ] && ~/.tmux/setup_$1.sh \
      || tmux new-session -s $1
  fi
fi
