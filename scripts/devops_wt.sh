#!/bin/bash

initials=$WORKTREE_INITIALS
directoryPrefix=$DEVOPS_WT_DIRECTORY_PREFIX
developSession=$DEVOPS_WT_DEVELOP_SESSION

set +x

if [ -z "$*" ]; then
  echo "Usage:"
  echo "  devops_wt [feature|fix|task] [name] [crabNumber]"
  echo "    Branch from the current directory, create a new Git worktree, start"
  echo "    a Tmux session for it, and build it for the first time."
  echo "  devops_wt sup [name] [supNumber]"
  echo "    Branch from the current directory, create a new Git worktree, start"
  echo "    a Tmux session for it, and build it for the first time."
  echo "  devops_wt checkout [branch] [name]"
  echo "    Check out the named branch in a new Git worktree, start a Tmux"
  echo "    session for it, and build it for the first time."
  echo "  devops_wt start [directory] [name]"
  echo "    Start a Tmux session for an existing Git worktree directory."
  echo "  devops_wt env"
  echo "    Load the installed environments for the given session."
  echo "  devops_wt build-from-scratch"
  echo "    Install and build"
  echo "  devops_wt build-first-time"
  echo "    Alias for devops_wt build - didn't used to be, of course"
  echo "  devops_wt build"
  echo "    Start a top-level build of the workspace."
  echo "  devops_wt ide [sessionName]"
  echo "    Run 'sq ide' from the top-level crab directory."
  echo "  devops_wt bitbucket"
  echo "    Open the current branch on BitBucket."
  echo "  devops_wt destroy"
  echo "    Remove the current worktree and close this Tmux session."
  exit 0
fi

function currentSession {
  tmux display-message -p '#S'
}

function sessionOrCurrent {
    if [ -z "$1" ]; then
      currentSession
    else
      echo $1
    fi
}

function createWindow {
  session=$1

  tmux send-keys -t $session:devops "cd $directory" C-m

  tmux split-window -h -t $session:devops $SHELL
  tmux send-keys -t $session:devops "cd $directory" C-m

  tmux select-layout -t $session:devops tiled
}

function createWorkspace {
  directory=$1
  session=$2

  tmux new-session -d -c $directory -s $session $SHELL
  tmux rename-window -t $session devops
  createWindow $session
  tmux switch-client -t $session
}

function buildFromScratch {
  session=$1

  tmux send-keys -t $session:devops.1 "./sq install && devops_wt env $session && devops_wt build-first-time $session" C-m
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
    tmux switch-client -t $name:0
    ;;
  start)
    directory=$2
    if [ -z "$3" ]; then
      name=$directory
    else
      name=$3
    fi

    createWorkspace $(realpath $2) $name
    ;;
  servers)
    directory=$(pwd)
    session=$(sessionOrCurrent $2)

    tmux new-window -t $session -n devops -c $directory $SHELL
    createWindow $(sessionOrCurrent $2)
    ;;
  env)
    session=$(currentSession)

    # tmux send-keys -t $session:devops.1 "source environment" C-m
    ;;
  build-from-scratch)
    buildFromScratch $(currentSession)
    ;;
  build-first-time)
    # tmux send-keys -t $(currentSession):servers.0 "sq build -f && sq image -n && ~/scripts/notify.sh" C-m
    ;;
  build)
    # tmux send-keys -t $(currentSession):servers.0 "sq build -f && sq image -n && ~/scripts/notify.sh" C-m
    ;;
  ide)
    session=$(sessionOrCurrent $2)

    tmux send-keys -t $session:devops.0 "sq ide" C-m
    ;;
  bitbucket)
    open https://bitbucket.org/seeq12/crab/branch/$(git rev-parse --abbrev-ref HEAD)
    ;;
  destroy)
    path=$(pwd)
    session=$(currentSession)

    git worktree remove $path && tmux switch-client -t $developSession && tmux kill-session -t $session
    ;;
esac
