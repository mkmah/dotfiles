# Dotfiles

> Dotfiles which I am using right now, I am changing it frequently. You can clone it, modify it and fork it, whatever you want. Happy coding!!!

## Initial setup

### Dependencies

First, make sure you have all the following installed:

- `git`: to clone the repository
- `curl`: to download files
- `tar`: to extract downloaded files
- `fish`: the shell
- `sudo`: some configurations may need that

```shell
brew install git curl tar fish
```

```bash
xcode-select --install
```

```bash
git clone https://github.com/mkmah/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

> **Note**
> This dotfiles configuration is set up in such a way that it _shouldn't_ matter where the repo exists on your system.

Before install you can change the workspace dir, by default it will be set to `~/workspace`

```shell
set -Ux WORKSPACE ~/workspace
```

Go directory will be set to `~/go`

```shell
set -gx GO_DIR ~/go
```

Change the above two based on your preference

The script, `install.fish` is the one-stop for all things setup, backup, and installation.

```bash
> ./install.fish help

Usage: install.fish {backup|fisher|link|git|homebrew|shell|macos|all}
```

### `backup`

```bash
install.fish backup
```

Create a backup of the current dotfiles (if any) into `~/.dotfiles-backup/`. This will scan for the existence of every file that is to be symlinked and will move them over to the backup directory. It will also do the same for vim setups, moving some files in the [XDG base directory](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html), (`~/.config`).

- `~/.config/nvim/` - The home of [neovim](https://neovim.io/) configuration
- `~/.vim/` - The home of vim configuration
- `~/.vimrc` - The main init file for vim

### `link`

```bash
./install.fish link
```

The `link` command will create [symbolic links](https://en.wikipedia.org/wiki/Symbolic_link) from the dotfiles directory into the `$HOME` directory, allowing for all of the configuration to _act_ as if it were there without being there, making it easier to maintain the dotfiles in isolation.

### `homebrew`

```bash
./install.fish homebrew
```

The `homebrew` command sets up [homebrew](https://brew.sh/) by downloading and running the homebrew installers script. Homebrew is a macOS package manager, but it also work on linux via Linuxbrew. If the script detects that you're installing the dotfiles on linux, it will use that instead. For consistency between operating systems, linuxbrew is set up but you may want to consider an alternate package manager for your particular system.

Once homebrew is installed, it executes the `brew bundle` command which will install the packages listed in the [Brewfile](./Brewfile).

### `shell`

```bash
./install.fish shell
```

The `shell` command sets up the recommended shell configuration for the dotfiles setup. Specifically, it sets the shell to [zsh](https://www.zsh.org/) using the `chsh` command.

### `macos`

```bash
./install.fish macos
```

The `macos` command sets up macOS-specific configurations using the `defaults write` commands to change default values for macOS.

- Finder: show all filename extensions
- show hidden files by default
- only use UTF-8 in Terminal.app
- expand save dialog by default
- Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
- Enable subpixel font rendering on non-Apple LCDs
- Use current directory as default search scope in Finder
- Show Path bar in Finder
- Show Status bar in Finder
- Disable press-and-hold for keys in favor of key repeat
- Set a blazingly fast keyboard repeat rate
- Set a shorter Delay until key repeat
- Enable tap to click (Trackpad)
- Enable Safari’s debug menu

### `all`

```bash
./install.fish all
```

This command runs all the installation tasks described above, in full, except the `backup` script. You must run that one manually.

## FISH Configuration

The prompt for FISH is configured in the `~/.config/fish` file and performs the following operations.

- Sets `EDITOR` to `nvim`
- Sets `CODE_DIR` to `~/workspace`. This can be changed to the location you use to put your git checkouts, and enables fast `cd`-ing into it via the `c` command
- Recursively searches the `$DOTFILES/config/*` or `$CONFIG_ROOT/*` directory for any `.fish` files and sources them
- Sources a `~/.localrc.fish`, if available for configuration that is machine-specific and/or should not ever be checked into git
- Adds `~/.bin`, `~/.local/bin` and `$DOTFILES/config/bin` to the `PATH`

### FISH plugins

The plugins are listed inside `config/fish/plugins` file.

- jorgebucaran/autopair.fish
- jethrokuan/fzf
- jorgebucaran/replay.fish
- jorgebucaran/fisher
- catppuccin/fish

### Themes and fonts

*Catppuccin Mocha* and *MonoLisa* Font.

### Prompt

Using [starship prompt](https://starship.rs/) which is creating using rust, and it is blazing fast.

You can customize the file `config/starship/config.toml`. For any advanced configuration follow [this](https://starship.rs/config/)

## Neovim setup

Neovim is configured from `config/nvim` which is a lazy neovim setup. [here](https://www.lazyvim.org/)

### Installing plugins

On the first run, all required plugins should automaticaly by installed by
[lazy.nvim](https://github.com/folke/lazy.nvim), a plugin manager for neovim.

All plugins are listed in [plugins.lua](./config/nvim/lua/plugins.lua). When a plugin is added, it will automatically be installed by lazy.nvim. To interface with lazy.nvim, simply run `:Lazy` from within vim.

> **Note**
> Plugins can be synced in a headless way from the command line using the `vimu` alias.

## tmux configuration

I prefer to run everything inside of [tmux](https://github.com/tmux/tmux). I typically use a large pane on the top for neovim and then multiple panes along the bottom or right side for various commands I may need to run. There are no pre-configured layouts in this repository, as I tend to create them on-the-fly and as needed.

This repo ships with a `tm` command which provides a list of active session, or provides prompts to create a new one.

```bash
> tm
Available sessions
------------------

1) New Session
Please choose your session: 1
Enter new session name: open-source
```

This configuration provides a bit of style to the tmux bar, along with some additional data such as the currently playing song (from Apple Music or Spotify), the system name, the session name, and the current time.

> **Note**
> It also changes the prefix from `⌃-b` to `⌃-a` (⌃ is the _control_ key). This is because I tend to remap the Caps Lock button to Control, and then having the prefix makes more sense.

### tmux key commands

Pressing the Prefix followed by the following will have the following actions in tmux.

| Command     | Description                    |
| ----------- | ------------------------------ |
| `h`         | Select the pane to the left    |
| `j`         | Select the pane to the bottom  |
| `k`         | Select the pane to the top     |
| `l`         | Select the pane to the right   |
| `⇧-H`       | Enlarge the pane to the left   |
| `⇧-J`       | Enlarge the pane to the bottom |
| `⇧-K`       | Enlarge the pane to the top    |
| `⇧-L`       | Enlarge the pane to the right  |
| `-` (dash)  | Create a vertical split        |
| `\|` (pipe) | Create a horizontal split      |

### Minimal tmux UI

Setting a `$TMUX_MINIMAL` environment variable will do some extra work to hide the tmux status bar when there is only a
single tmux window open. This is not the default in this repo because it can be confusing, but it is my preferred way to
work. To set this, you can use the `~/.localrc.fish` file to set it in the following way.

```shell
export TMUX_MINIMAL=1
```

## Revert

Reverting is not totally automated, but it pretty much consists in removing the
fish configuration and the `.dotfiles` folder, as well as moving back some other
configuration files:

```console
rm -rf ~/.dotfiles $__fish_config_dir
```

## Questions

If you have questions, notice issues, or would like to see improvements, please open a new [discussion](https://github.com/mkmah/dotfiles/discussions/new) and I'm happy to help you out!
