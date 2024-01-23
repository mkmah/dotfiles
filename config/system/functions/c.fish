function c -d "quick cd into $WORKSPACE"
	switch $argv[1]
	case ''
		cd $WORKSPACE
	case '*'
		cd $WORKSPACE/$argv[1]
	end
end

function __c_complete
	set arg (commandline -ct)
	set saved_pwd $PWD

	builtin cd $WORKSPACE
		and complete -C "cd $arg"

	builtin cd $saved_pwd
end

complete --command c --arguments '(__c_complete)'
