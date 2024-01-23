#!/usr/bin/env fish
set -Ux EDITOR nvim
set -Ux VISUAL $EDITOR

fish_add_path -a $CONFIG_ROOT/bin $HOME/.bin $HOME/.local/bin

for f in $CONFIG_ROOT/*/functions
	if not contains $f $fish_function_path
		set -Up fish_function_path $f
	end
end

for f in $CONFIG_ROOT/*/conf.d/*.fish
	ln -sf $f $__fish_config_dir/conf.d/(basename $f)
end

if test -f ~/.localrc.fish
	ln -sf ~/.localrc.fish $__fish_config_dir/conf.d/localrc.fish
end
