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

## tmux basics

Create or attach to a session from your shell:

```bash
tmux new-session -A -s main
```

Useful shell commands:

- `tmux ls` → list sessions
- `tmux attach -t main` → attach to a session
- `tmux kill-session -t main` → kill a session
- `tmux source-file ~/.config/tmux/tmux.conf` → reload config from the shell

## Keybindings in this config

In this config, `prefix` is the default tmux prefix: `Ctrl-b`.

These are the custom bindings actually defined in `tmux.conf`:

### Pane and window navigation

- `prefix + h/j/k/l` → move between panes with Vim keys
- `Alt + Left/Right/Up/Down` → move between panes without prefix
- `Shift + Left/Right` → previous/next window without prefix
- `Alt + Shift + H/L` → previous/next window without prefix

### Splits and windows

- `prefix + "` → split the current pane top/bottom
- `prefix + %` → split the current pane left/right
- `prefix + c` → create a new window in the current pane's working directory

## Useful default tmux shortcuts

These are standard tmux shortcuts you can use even though they are not customized here.

### Sessions

- `prefix + d` → detach from the current session
- `prefix + s` → choose a session
- `prefix + $` → rename the current session

### Windows / tabs

In tmux, a “tab” is a window.

- `prefix + c` → create a new window
- `prefix + n` → next window
- `prefix + p` → previous window
- `prefix + 0..9` → jump to a specific window number
- `prefix + w` → choose a window
- `prefix + ,` → rename the current window
- `prefix + &` → close the current window

### Panes

- `prefix + "` → split vertically
- `prefix + %` → split horizontally
- `prefix + arrow keys` → move between panes
- `prefix + o` → go to the next pane
- `prefix + ;` → switch to the last active pane
- `prefix + x` → close the current pane
- `prefix + z` → zoom/unzoom the current pane
- `prefix + q` → show pane numbers

### Copy mode

- `prefix + [` → enter copy mode
- `prefix + ]` → paste from tmux buffer

### Floating popup window

There is no dedicated popup keybinding in the current `tmux.conf`, but on tmux versions that support popups you can open one with the command prompt:

```text
prefix + :
display-popup -E -d "#{pane_current_path}"
```

Or from your shell:

```bash
tmux display-popup -E
```

## Plugin manager

- `prefix + I` → install plugins
- `prefix + U` → update plugins
- `prefix + Alt-u` → clean unused plugins

## Notes

- Mouse support is enabled.
- Windows and panes start at index `1` instead of `0`.
- New windows and splits open in the current pane's working directory.
- The `run '~/.tmux/plugins/tpm-redux/tpm'` line should stay at the bottom of `tmux.conf`.
