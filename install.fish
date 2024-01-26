#!/usr/bin/env fish
#
# bootstrap installs things.

set -Ux DOTFILES (pwd -P)
set -Ux WORKSPACE ~/workspace
set -gx GO_DIR ~/go
set BACKUP_DIR $HOME/dotfiles-backup
set -Ux CONFIG_ROOT $DOTFILES/config

function title
	echo -e
	set total_length (math (string length $argv)+2)
	set term_width (tput cols)
	set start_length (math round (math $term_width-$total_length)/2)
	set end_length (math $start_length-(math $term_width % 2))
    echo (set_color --bold grey)(string repeat -n$start_length =) (set_color --background blue --bold brcyan)$argv(set_color normal) (set_color --bold grey)(string repeat -n$end_length =)(set_color normal)
    echo -e
end

function info
	echo [(set_color --bold) ' INFO ' (set_color normal)] $argv
end

function user
	echo [(set_color --bold) '  ??  ' (set_color normal)] $argv
end

function success
	echo [(set_color --bold green) '  OK  ' (set_color normal)] (set_color --bold green)$argv(set_color --bold normal)
end

function warning
	echo [(set_color --bold yellow) ' WARN ' (set_color normal)] $argv
end

function abort
	echo [(set_color --bold yellow) ' ABRT ' (set_color normal)] $argv
	exit 1
end

function on_exit -p %self
	if not contains $argv[3] 0
		echo [(set_color --bold red) ' FAIL ' (set_color normal)] "Couldn't setup dotfiles, please open an issue at https://github.com/mkmah/dotfiles"
	end
end

function backup -d "backs up all the symlink files present"
	title 'Creating backups'

	if test -d $BACKUP_DIR
		info "Removing backup directory"
		rm -r $BACKUP_DIR
	end

	info "Creating backup directory at $BACKUP_DIR"
	mkdir -p "$BACKUP_DIR"

	for file in $CONFIG_ROOT/*/*.symlink
		set filename .(basename $file '.symlink')
		set target "$HOME/$filename"
		if test -e $target
			info "backing up $filename"
			cp $target $BACKUP_DIR
		else
			warning "$filename does not exist at this location or is a symlink"
		end
	end

	for filename in "$HOME/.config/nvim" "$HOME/.vim" "$HOME/.vimrc"
		if test -e $filename
			info "backing up $filename"
			cp -rf $filename $BACKUP_DIR
		else
			warning "$filename does not exist at this location or is a symlink"
		end
	end
end

function setup_fisher
	title "Installing fisher"

	curl -sL git.io/fisher | source && fisher install jorgebucaran/fisher
end

function setup_brew
	title "Setting up Homebrew"

	if ! command -q brew
    	info 'Homebrew not installed. Installing'
		curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
    end

	# install brew dependencies from Brewfile
    brew bundle

	# install fzf
	echo -e
	info "Installing fzf"
	set brew_prefix (brew --prefix)
	$brew_prefix/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-zsh
end

function setup_gitconfig
	set managed (git config --global --get dotfiles.managed)
	# if there is no user.email, we'll assume it's a new machine/setup and ask it
	if test -z (git config --global --get user.email)
		user 'What is your github author name?'
		read user_name
		user 'What is your github author email?'
		read user_email

		test -n $user_name
			or echo "please inform the git author name"
		test -n $user_email
			or abort "please inform the git author email"

		git config --global user.name $user_name
			and git config --global user.email $user_email
			or abort 'failed to setup git user name and email'
	else if test "$managed" != "true"
		# if user.email exists, let's check for dotfiles.managed config. If it is
		# not true, we'll backup the gitconfig file and set previous user.email and
		# user.name in the new one
		set user_name (git config --global --get user.name)
			and set user_email (git config --global --get user.email)
			and mv ~/.gitconfig ~/.gitconfig.backup
			and git config --global user.name $user_name
			and git config --global user.email $user_email
			and success "moved ~/.gitconfig to ~/.gitconfig.backup"
			or abort 'failed to setup git user name and email'
	else
		# otherwise this gitconfig was already made by the dotfiles
		info "already managed by dotfiles"
	end
	# include the gitconfig.local file
	# finally make git knows this is a managed config already, preventing later
	# overrides by this script
	git config --global include.path ~/.gitconfig.local
		and git config --global dotfiles.managed true
		or abort 'failed to setup git'
end

function link_file -d "links a file keeping a backup"
	echo $argv | read -l old new backup
	if test -e $new
		set newf (readlink $new)
		if test "$newf" = "$old"
			success "skipped $old"
			return
		else
			mv $new $new.$backup
				and success moved $new to $new.$backup
				or abort "failed to backup $new to $new.$backup"
		end
	end
	mkdir -p (dirname $new)
		and ln -sf $old $new
		and success "linked $old to $new"
		or abort "could not link $old to $new"
end

function setup_symlinks
	title "Setting symlinks and dotfiles"

	for src in $CONFIG_ROOT/*/*.symlink
		link_file $src $HOME/.(basename $src .symlink) backup
			or abort 'failed to link config file'
	end

	link_file $CONFIG_ROOT/fish/plugins $__fish_config_dir/fish_plugins backup
		or abort plugins
	link_file $CONFIG_ROOT/system/bat.config $HOME/.config/bat/config backup
		or abort bat
	link_file $CONFIG_ROOT/htop/htoprc $HOME/.config/htop/htoprc backup
		or abort htoprc
	link_file $CONFIG_ROOT/ssh/config.dotfiles $HOME/.ssh/config.dotfiles backup
		or abort ssh-config
	link_file $CONFIG_ROOT/ssh/rc $HOME/.ssh/rc backup
		or abort ssh-rc
	link_file $CONFIG_ROOT/kitty/kitty.conf $HOME/.config/kitty/kitty.conf backup
		or abort kitty
	link_file $CONFIG_ROOT/kitty/macos-launch-services-cmdline $HOME/.config/kitty/macos-launch-services-cmdline backup
		or abort kitty
	link_file $CONFIG_ROOT/wezterm $HOME/.config/wezterm backup
		or abort wezterm
	link_file $CONFIG_ROOT/nvim/config $HOME/.config/nvim backup
		or abort nvim
	link_file $CONFIG_ROOT/yamllint/config $HOME/.config/yamllint/config backup
		or abort yamllint
end

function install
	title "Installing fish plugins using fisher"

	fisher update
		and success 'plugins'
		or abort 'plugins'

	yes | fish_config theme save "Catppuccin Mocha"
    	and success 'colorscheme'
    	or abort 'colorscheme'

	mkdir -p $__fish_config_dir/completions/
		and success 'completions'
		or abort 'completions'

	$CONFIG_ROOT/install.fish
    	and success "entry install.fish"
    	or abort "entry install.fish"

	for installer in $CONFIG_ROOT/*/install.fish
		$installer
			and success $installer
			or abort $installer
	end
end

function setup_shell
	title "Configuring shell"

	if ! grep (command -v fish) /etc/shells
    	command -v fish | sudo tee -a /etc/shells
    		and success 'added fish to /etc/shells'
    		or abort 'setup /etc/shells'
    	echo
    end

    if ! test (which fish) = $SHELL
    	chsh -s (which fish)
			and success set (fish --version) as the default shell
			or abort 'set fish as default shell'
    end
end

function macos
	title "Configuring macos"
	bash $CONFIG_ROOT/macos/set-defaults.sh
end

function usage
	set base (basename (status -f))
	echo -e "\nUsage: $base {backup|fisher|link|git|brew|shell|macos|all}"
	exit 0
end

if not set -q argv[1]
    usage
end

switch $argv[1]
	case backup
		backup
			and success 'backup'
            or abort 'backup'
    case fisher
    	setup_fisher
    		and success 'fisher'
           	or abort 'fisher'
    case link
    	setup_symlinks
			and success 'symlinks'
			or abort 'symlinks'
    case brew
    	setup_brew
			and success 'homebrew'
			or abort 'homebrew'
	case git
		setup_gitconfig
			and success 'gitconfig'
			or abort 'gitconfig'
	case install
		install
			and success 'install'
            or abort 'install'
	case shell
		setup_shell
			and success 'shell'
			or abort 'shell'
	case macos
    	macos
    		and success 'macos'
            or abort 'macos'
    case all
    	setup_brew
			and success 'homebrew'
			or abort 'homebrew'
    	setup_fisher
    		and success 'fisher'
            or abort 'fisher'
    	setup_gitconfig
			and success 'gitconfig'
			or abort 'gitconfig'
		setup_symlinks
            and success 'symlinks'
            or abort 'symlinks'
		install
			and success 'install'
        	or abort 'install'
		setup_shell
			and success 'shell'
            or abort 'shell'
        macos
        	and success 'macos'
            or abort 'macos'
        success 'dotfiles installed/updated!'
	case '*'
		usage
end
