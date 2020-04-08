#!/bin/bash

initials=$WORKTREE_INITIALS
directoryPrefix=$WORKTREE_DIRECTORY_PREFIX
developSession=$WORKTREE_DEVELOP_SESSION

set +x

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
  echo "  worktree servers [sessionName]"
  echo "    Create a window with the standard server panes."
  echo "  worktree env"
  echo "    Load the installed environments for the given session."
  echo "  worktree build-from-scratch"
  echo "    Install, build, and launch IDE"
  echo "  worktree build-first-time"
  echo "    Build and launch IDE"
  echo "  worktree build"
  echo "    Start a top-level build of the workspace."
  echo "  worktree ide [sessionName]"
  echo "    Run 'sq ide' from the top-level crab directory."
  echo "  worktree update-sdk [sessionName]"
  echo "    Start a top-level build of the workspace."
  echo "  worktree db"
  echo "    Run 'sq db client' in a new window."
  echo "  worktree bitbucket"
  echo "    Open the current branch on BitBucket."
  echo "  worktree run"
  echo "    Run everything."
  echo "  worktree destroy"
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

function createServersWindow {
  session=$1

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
}

function createWorkspace {
  directory=$1
  session=$2

  tmux new-session -d -c $directory -s $session bash
  tmux rename-window -t $session servers
  createServersWindow $session
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
    branch=feature2/$initials/$name-CRAB-$crab

    git branch $branch
    git worktree add $directoryPrefix-$name $branch
    createWorkspace $directoryPrefix-$name $name
    buildFromScratch $name
    ;;
  fix)
    name=$2
    crab=$3
    branch=bugfix2/$initials/$name-CRAB-$crab

    git branch $branch
    git worktree add $directoryPrefix-$name $branch
    createWorkspace $directoryPrefix-$name $name
    buildFromScratch $name
    ;;
  task)
    name=$2
    crab=$3
    branch=task2/$initials/$name-CRAB-$crab

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

    tmux new-window -t $session -n servers -c $directory bash
    createServersWindow $(sessionOrCurrent $2)
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
  build)
    tmux send-keys -t $(currentSession):servers.0 "sq build -f && sq image -n" C-m
    ;;
  ide)
    session=$(sessionOrCurrent $2)

    tmux send-keys -t $session:servers.0 "sq ide" C-m
    ;;
  update-sdk)
    session=$(sessionOrCurrent $2)
    directory=$(pwd)

    tmux new-window -t $session -n update-sdk -c $directory
    tmux send-keys -t $session:update-sdk "bash -c 'cd appserver && . environment && sq build -f' && bash -c 'cd sdk && . environment && sq build -f'" C-m
    ;;
  run)
    session=$(sessionOrCurrent $2)

    tmux send-keys -t $session:servers.1 "sq db start" C-m
    tmux send-keys -t $session:servers.2 "sq run --appserverOnly" C-m
    tmux send-keys -t $session:servers.3 "sq run" C-m
    tmux send-keys -t $session:servers.4 "grunt server" C-m
    tmux send-keys -t $session:servers.5 "sq run" C-m
    ;;
  db)
    session=$(currentSession)
    directory=$(pwd)

    tmux new-window -t $session -n db -c $directory
    tmux send-keys -t $session:db "bash -c 'cd appserver && . environment && sq db client'" C-m
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
