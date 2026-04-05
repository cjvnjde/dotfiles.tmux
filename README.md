# tmux

This module manages the tmux config in `~/.config/tmux` and uses [tpm-redux](https://github.com/RyanMacG/tpm-redux) as the plugin manager.

## What setup does

When the `tmux` module is enabled from `~/dotfiles/setup.sh`, the tmux setup script will:

1. symlink this directory to `~/.config/tmux`
2. check whether `tpm-redux` is already installed in `~/.tmux/plugins/tpm-redux`
3. if it is not installed, ask whether you want to install it
4. clone it if you answer yes

If `tpm-redux` is already installed, setup does nothing and does not ask again.
If it is not installed and you answer no, setup will ask again on the next run.

## Install with the main dotfiles setup

Make sure `tmux` is enabled in your `.modules` file, then run:

```bash
cd ~/dotfiles
bash setup.sh
```

If `tpm-redux` is not installed yet, the tmux module will ask:

```text
Install tpm-redux for tmux plugin management? [Y/n]
```

After that, start tmux and install the plugins declared in `tmux.conf` with:

```text
prefix + I
```

In this config, `prefix` is the default tmux prefix: `Ctrl-b`.

## Manual plugin manager install

If you do not want setup to install it when prompted, you can install it yourself:

```bash
git clone https://github.com/RyanMacG/tpm-redux.git ~/.tmux/plugins/tpm-redux
```

Then reload tmux:

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

## Current plugins

This config currently declares:

- `tmux-plugins/tmux-sensible`
- `christoomey/vim-tmux-navigator`
- `tmux-plugins/tmux-resurrect`

## How to add a new tmux plugin

Open `tmux.conf` and add another plugin line **above** the final `run` line.

Example:

```tmux
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-yank'

run '~/.tmux/plugins/tpm-redux/tpm'
```

Then reload the config and install the new plugin:

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

Inside tmux:

```text
prefix + I
```

## tpm-redux keybindings

- `prefix + I` → install plugins
- `prefix + U` → update plugins
- `prefix + Alt-u` → clean unused plugins

## tmux basics

Create or attach to a session:

```bash
tmux new-session -A -s main
```

Useful commands:

- `tmux ls` → list sessions
- `tmux attach -t main` → attach to a session
- `tmux kill-session -t main` → kill a session

Inside tmux:

- `prefix + d` → detach
- `prefix + ,` → rename current window
- `prefix + $` → rename current session

## Keybindings in this config

### Pane and window movement

- `prefix + h/j/k/l` → move between panes with Vim keys
- `Alt + Left/Right/Up/Down` → move between panes without prefix
- `Shift + Left/Right` → move to previous/next window
- `Alt + Shift + H/L` → move to previous/next window

### Splits and windows

- `prefix + "` → split the current pane top/bottom
- `prefix + %` → split the current pane left/right
- `prefix + c` → create a new window

Splits and new windows open in the current pane's working directory.

## Notes

- Mouse support is enabled.
- Windows and panes start at index `1` instead of `0`.
- The `run '~/.tmux/plugins/tpm-redux/tpm'` line should stay at the bottom of `tmux.conf`.
