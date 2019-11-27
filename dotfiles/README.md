Dotfiles
========

So we can pair like normal, productive members of society.

Installation
----------------------

### Vim

1. Install [vundle](https://github.com/gmarik/vundle)

2. Add `source ~/Path/to/dotfiles/.vimrc` to the bottom of `~/.vimrc`

3. Launch vim and run `:BundleInstall` to install team plugins

### Tmux

1. Install Tmux: http://tmux.sourceforge.net/. I use homebrew (http://mxcl.github.io/homebrew/): `brew install tmux`

1. You may have to install `reattach-to-user-namespace`: `brew install reattach-to-user-namespace`

1. Make a symbolic link to `.tmux.conf` in your home directory: `cd ~ && ln -s ~/Path/to/dotfiles/.tmux.conf ./`

1. Create a `.tmux` directory in your home directory: `mkdir ~/.tmux`

1. Make a symbolic link to `tmux.sh` in the newly created directory: `cd ~/.tmux && ln -s ~/Path/to/dotfiles/.tmux/tmux.sh ./`

1. Add an alias to your `.bashrc`: `alias tm="~/.tmux/tmux.sh"`

1. Create any start-up scripts for environments you want.  They should go in the `.tmux` directory and be shell scripts whose names begin with 'setup_' (make sure they're executable -- `chmod +x`).  Here is an example for a start-up script for the PWA (run using `tm pwa`):

```bash
# ~/.tmux/setup_thing.sh
# setup thing environment
tmux new-session -d -s thing

tmux rename-window -t pwa:1 'procs'
tmux send-keys -t 1 'cd ~/workspace/thing && clear && ./script/coffee' C-m
tmux split-window -v
tmux send-keys -t 1 'memcached -d' C-m
tmux send-keys -t 1 'cd ~/workspace/thing && clear && bundle exec guard' C-m

tmux new-window -t pwa:2 -n 'shell'
tmux send-keys -t 2 'cd ~/workspace/thing && clear' C-m
tmux split-window -v
tmux send-keys -t 2 'cd ~/workspace/thing && clear' C-m

tmux new-window -t pwa:3 -n 'vim'
tmux send-keys -t 3 'cd ~/workspace/thing && clear && vim .' C-m

tmux new-window -t pwa:4 -n 'servers'
tmux send-keys -t 4 'cd ~/workspace/thing && clear' C-m
tmux split-window -v
tmux send-keys -t 4 'cd ~/workspace/thing && clear' C-m

tmux select-window -t thing:3
tmux a
```

Usage
----------------------

### Tmux

#### Know Tmux already?

You probably just want to know what's in `.tmux.conf` and `.tmux/tmux.sh`. Here is the quick summary:

1. `` ` `` (backtick) is the prefix (no longer `C-b`). You can make `C-b` the prefix again by hitting F10 and switch back by hitting F9.

2. You can create splits easily with `` ` |`` and `` ` -``

3. You can resize panes easily with  `` ` C-h``, `` ` C-j``, `` ` C-k``, `` ` C-l``

4. You can now put session startup scripts in the `~/.tmux/` directory. If you create one called `setup_optisuite.sh`, you can execute it on tmux startup using `tm optisuite`.

#### New to Tmux?

You may want to find a Tmux tutorial.  When reading through it be aware that, if you've installed this repo's `.tmux.conf`, you'll be using `` ` `` instead of `C-b`.

##### Day-to-day stuff

Here are the tmux (and custom) commands I use on a day-to-day basis:

1. `tm pwa` -- start tmux and run ~/.tmux/setup_pwa.sh or reattach if the session was already started

1. `` ` d`` -- detach from the tmux session

1. `` ` s`` -- switch between tmux sessions

1. `` ` c`` -- create a new window in the tmux session

1. `` ` 1 (2, 3, etc.)`` -- switch between tmux windows

1. `` ` |`` -- create a vertical pane split

1. `` ` -`` -- create a horizontal pane split

1. `` ` o`` -- go to the next pane

1. `` ` ;`` -- switch back and forth between the two most recently used panes

1. `` ` x`` -- kill a pane

1. `` ` pageup`` -- scroll the current pane -- press `Esc` to exit scrolling (it's not the best solution; open to fixes but it works)
