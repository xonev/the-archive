#!/bin/bash

set +x
initials="sajo"
directoryPrefix=/Users/soxley/workspace/seeq/crab
developSession=develop

if [ -z "$*" ]; then
  echo "Usage:"
  echo "  worktree [feature|fix|task] [name] [crabNumber]"
  echo "    Branch from the current directory, create a new Git worktree, start"
  echo "    a Tmux session for it, and build it for the first time."
  echo "  worktree sup [name] [supNumber]"
  echo "    Branch from the current directory, create a new Git worktree, start"
  echo "    a Tmux session for it, and build it for the first time."
  echo "  worktree checkout [branch] [name]"
  echo "    Check out the named branch in a new Git worktree, start a Tmux"
  echo "    session for it, and build it for the first time."
  echo "  worktree start [directory] [name]"
  echo "    Start a Tmux session for an existing Git worktree directory."
  echo "  worktree env"
  echo "    Load the installed environments for the given session."
  echo "  worktree build-first-time"
  echo "    Trigger a top-level build of the workspace."
  echo "  worktree update-sdk [session-name]"
  echo "    Trigger a top-level build of the workspace."
  echo "  worktree destroy"
  echo "    Remove the current worktree and close this Tmux session."
  exit 0
fi

function currentSession {
  tmux display-message -p '#S'
}

function createWorkspace {
  directory=$1
  session=$2

  echo "Creating in directory $directory..."

  tmux new-session -d -c $directory -s $session bash
  tmux rename-window -t $session:1 servers
  tmux send-keys -t $session:servers "cd $directory" C-m

  tmux split-window -h -t $session:servers bash
  tmux send-keys -t $session:servers "cd $directory/appserver" C-m

  tmux split-window -h -t $session:servers bash
  tmux send-keys -t $session:servers "cd $directory/appserver" C-m

  tmux split-window -h -t $session:servers bash
  tmux send-keys -t $session:servers "cd $directory/jvm-link" C-m

  tmux select-layout -t $session:servers even-horizontal

  tmux split-window -h -t $session:servers bash
  tmux send-keys -t $session:servers "cd $directory/webserver" C-m

  tmux split-window -h -t $session:servers bash
  tmux send-keys -t $session:servers "cd $directory/webserver" C-m

  tmux select-layout -t $session:servers tiled

  tmux switch-client -t $session
}

function buildFromScratch {
  session=$1

  tmux send-keys -t $session:servers.0 "./sq install && worktree env $session && worktree build-first-time $session" C-m
}

case $1 in
  feature)
    name=$2
    crab=$3
    branch=feature/$initials/$name-CRAB-$crab

    git branch $branch
    git worktree add $directoryPrefix-$name $branch
    createWorkspace $directoryPrefix-$name $name
    buildFromScratch $name
    ;;
  fix)
    name=$2
    crab=$3
    branch=bugfix/$initials/$name-CRAB-$crab

    git branch $branch
    git worktree add $directoryPrefix-$name $branch
    createWorkspace $directoryPrefix-$name $name
    buildFromScratch $name
    ;;
  task)
    name=$2
    crab=$3
    branch=task/$initials/$name-CRAB-$crab

    git branch $branch
    git worktree add $directoryPrefix-$name $branch
    createWorkspace $directoryPrefix-$name $name
    buildFromScratch $name
    ;;
  sup)
    name=$2
    sup=$3
    branch=sup/$initials/$name-SUP-$sup

    git branch $branch
    git worktree add $directoryPrefix-$name $branch
    createWorkspace $directoryPrefix-$name $name
    buildFromScratch $name
    ;;
  checkout)
    branch=$2
    name=$3

    git worktree add $directoryPrefix-$name $branch
    createWorkspace $directoryPrefix-$name $name
    buildFromScratch $name
    ;;
  remote-checkout)
    branch=$2
    name=$3

    git branch "$branch" "origin/$branch"
    git worktree add $directoryPrefix-$name "$branch"
    createWorkspace $directoryPrefix-$name $name
    buildFromScratch $name
    ;;
  start)
    directory=$2
    name=$3

    createWorkspace $(realpath $2) $name
    ;;
  env)
    session=$(currentSession)

    tmux send-keys -t $session:servers.0 ". environment" C-m
    tmux send-keys -t $session:servers.1 ". environment" C-m
    tmux send-keys -t $session:servers.2 ". environment" C-m
    tmux send-keys -t $session:servers.3 ". environment" C-m
    tmux send-keys -t $session:servers.4 ". environment" C-m
    tmux send-keys -t $session:servers.5 ". environment" C-m
    ;;
  build-from-scratch)
     buildFromScratch $(currentSession)
    ;;
  build-first-time)
    tmux send-keys -t $(currentSession):servers.0 "sq build -f && sq image -n && sq ide" C-m
    ;;
  update-sdk)
    directory=$(pwd)
    if [ -z "$2" ]; then
      session=$(currentSession)
    else
      session=$2
    fi
    tmux new-window -t $session -n update-sdk -c $directory
    tmux send-keys -t $session:update-sdk "bash -c 'cd appserver && . environment && sq build -f' && bash -c 'cd sdk && . environment && sq build -f'" C-m
    ;;
  destroy)
    path=$(pwd)
    session=$(currentSession)

    tmux switch-client -t $developSession
    tmux send-keys -t $developSession "git worktree remove $path" C-m
    tmux kill-session -t $session
    ;;
esac
