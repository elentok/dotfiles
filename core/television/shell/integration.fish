function __tv_parse_commandline --description 'Parse the current command line token and return split of existing filepath, and query'
    # credits to the junegunn/fzf project
    # https://github.com/junegunn/fzf/blob/9c1a47acf7453f9dad5905b7f23ad06e5195d51f/shell/key-bindings.fish#L53-L131

    set -l tv_query ''
    set -l prefix ''
    set -l dir '.'

    # Set variables containing the major and minor fish version numbers, using
    # a method compatible with all supported fish versions.
    set -l -- fish_major (string match -r -- '^\d+' $version)
    set -l -- fish_minor (string match -r -- '^\d+\.(\d+)' $version)[2]

    # fish v3.3.0 and newer: Don't use option prefix if " -- " is preceded.
    set -l -- match_regex '(?<tv_query>[\s\S]*?(?=\n?$)$)'
    set -l -- prefix_regex '^-[^\s=]+=|^-(?!-)\S'
    if test "$fish_major" -eq 3 -a "$fish_minor" -lt 3
        or string match -q -v -- '* -- *' (string sub -l (commandline -Cp) -- (commandline -p))
        set -- match_regex "(?<prefix>$prefix_regex)?$match_regex"
    end

    # Set $prefix and expanded $tv_query with preserved trailing newlines.
    if test "$fish_major" -ge 4
        # fish v4.0.0 and newer
        string match -q -r -- $match_regex (commandline --current-token --tokens-expanded | string collect -N)
    else if test "$fish_major" -eq 3 -a "$fish_minor" -ge 2
        # fish v3.2.0 - v3.7.1 (last v3)
        string match -q -r -- $match_regex (commandline --current-token --tokenize | string collect -N)
        eval set -- tv_query (string escape -n -- $tv_query | string replace -r -a '^\\\(?=~)|\\\(?=\$\w)' '')
    else
        # fish older than v3.2.0 (v3.1b1 - v3.1.2)
        set -l -- cl_token (commandline --current-token --tokenize | string collect -N)
        set -- prefix (string match -r -- $prefix_regex $cl_token)
        set -- tv_query (string replace -- "$prefix" '' $cl_token | string collect -N)
        eval set -- tv_query (string escape -n -- $tv_query | string replace -r -a '^\\\(?=~)|\\\(?=\$\w)|\\\n\\\n$' '')
    end

    if test -n "$tv_query"
        # Normalize path in $tv_query, set $dir to the longest existing directory.
        if test \( "$fish_major" -ge 4 \) -o \( "$fish_major" -eq 3 -a "$fish_minor" -ge 5 \)
            # fish v3.5.0 and newer
            set -- tv_query (path normalize -- $tv_query)
            set -- dir $tv_query
            while not path is -d $dir
                set -- dir (path dirname $dir)
            end
        else
            # fish older than v3.5.0 (v3.1b1 - v3.4.1)
            if test "$fish_major" -eq 3 -a "$fish_minor" -ge 2
                # fish v3.2.0 - v3.4.1
                string match -q -r -- '(?<tv_query>^[\s\S]*?(?=\n?$)$)' \
                    (string replace -r -a -- '(?<=/)/|(?<!^)/+(?!\n)$' '' $tv_query | string collect -N)
            else
                # fish v3.1b1 - v3.1.2
                set -- tv_query (string replace -r -a -- '(?<=/)/|(?<!^)/+(?!\n)$' '' $tv_query | string collect -N)
                eval set -- tv_query (string escape -n -- $tv_query | string replace -r '\\\n$' '')
            end
            set -- dir $tv_query
            while not test -d "$dir"
                set -- dir (dirname -z -- "$dir" | string split0)
            end
        end

        if not string match -q -- '.' $dir; or string match -q -r -- '^\./|^\.$' $tv_query
            # Strip $dir from $tv_query - preserve trailing newlines.
            if test "$fish_major" -ge 4
                # fish v4.0.0 and newer
                string match -q -r -- '^'(string escape --style=regex -- $dir)'/?(?<tv_query>[\s\S]*)' $tv_query
            else if test "$fish_major" -eq 3 -a "$fish_minor" -ge 2
                # fish v3.2.0 - v3.7.1 (last v3)
                string match -q -r -- '^/?(?<tv_query>[\s\S]*?(?=\n?$)$)' \
                    (string replace -- "$dir" '' $tv_query | string collect -N)
            else
                # fish older than v3.2.0 (v3.1b1 - v3.1.2)
                set -- tv_query (string replace -- "$dir" '' $tv_query | string collect -N)
                eval set -- tv_query (string escape -n -- $tv_query | string replace -r -a '^/?|\\\n$' '')
            end
        end
    end

    # Ensure $dir ends with a slash if it's a directory
    if test -d "$dir"; and not string match -q '*/$' -- $dir
        set dir "$dir/"
    end

    string escape -n -- "$dir" "$tv_query" "$prefix"

end

function tv_smart_autocomplete
    set -l commandline (__tv_parse_commandline)
    set -lx dir $commandline[1]
    set -l tv_query $commandline[2]

    # prefix (lhs of cursor)
    set -l current_prompt (commandline --current-process)

    # move to the next line so that the prompt is not overwritten
    printf "\n"

    if set -l result (tv $dir --autocomplete-prompt "$current_prompt" --input $tv_query --inline)
        # Remove last token from commandline.
        commandline -t ''

        # If dir is the current directory, i.e. './' , clear it.
        # If the pattern './foo' './bar' instead of 'foo' 'bar' is desired then comment out the check below
        if test "$dir" = "./"
            set dir ""
        end

        for i in $result
            commandline -t -- (string escape -- "$dir$i")' '
            # optional, if you want to replace '/home/foo/' with '~/', comment out above and uncomment below
            # commandline -t -- (string replace --all $HOME '~' -- (string escape -- "$dir$i"))' '
        end
    end

    # move the cursor back to the previous line
    printf "\033[A"

    commandline -f repaint
end

function tv_shell_history
    set -l current_prompt (commandline -cp)

    # move to the next line so that the prompt is not overwritten
    printf "\n"

    set -l output (tv fish-history --input "$current_prompt" --inline)

    if test -n "$output"
        commandline -r "$output"
    end
    # move the cursor back to the previous line
    printf "\033[A"
    commandline -f repaint
end

for mode in default insert
    bind --mode $mode \cT tv_smart_autocomplete
    bind --mode $mode \cR tv_shell_history
end
# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_tv_global_optspecs
	string join \n preview-offset= no-preview hide-preview show-preview no-status-bar hide-status-bar show-status-bar t/tick-rate= watch= k/keybindings= expect= i/input= input-header= input-prompt= input-border= input-padding= preview-header= preview-footer= preview-border= preview-padding= hide-preview-scrollbar s/source-command= ansi source-display= source-output= results-border= results-padding= source-entry-delimiter= p/preview-command= cache-preview layout= autocomplete-prompt= exact select-1 take-1 take-1-fast no-remote hide-remote show-remote no-help-panel hide-help-panel show-help-panel ui-scale= preview-size= config-file= cable-dir= global-history height= width= inline h/help V/version
end

function __fish_tv_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_tv_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_tv_using_subcommand
	set -l cmd (__fish_tv_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c tv -n "__fish_tv_needs_command" -l preview-offset -d 'A preview line number offset template to use to scroll the preview to for each entry.' -r
complete -c tv -n "__fish_tv_needs_command" -s t -l tick-rate -d 'The application\'s tick rate.' -r
complete -c tv -n "__fish_tv_needs_command" -l watch -d 'Watch mode: reload the source command every N seconds.' -r
complete -c tv -n "__fish_tv_needs_command" -s k -l keybindings -d 'Keybindings to override the default keybindings.' -r
complete -c tv -n "__fish_tv_needs_command" -l expect -d 'Keys that can be used to confirm the current selection in addition to the default ones (typically `enter`).' -r
complete -c tv -n "__fish_tv_needs_command" -s i -l input -d 'Input text to pass to the channel to prefill the prompt.' -r
complete -c tv -n "__fish_tv_needs_command" -l input-header -d 'Input field header template.' -r
complete -c tv -n "__fish_tv_needs_command" -l input-prompt -d 'Input prompt string' -r
complete -c tv -n "__fish_tv_needs_command" -l input-border -d 'Sets the input panel border type.' -r -f -a "none\t''
plain\t''
rounded\t''
thick\t''"
complete -c tv -n "__fish_tv_needs_command" -l input-padding -d 'Sets the input panel padding.' -r
complete -c tv -n "__fish_tv_needs_command" -l preview-header -d 'Preview header template' -r
complete -c tv -n "__fish_tv_needs_command" -l preview-footer -d 'Preview footer template' -r
complete -c tv -n "__fish_tv_needs_command" -l preview-border -d 'Sets the preview panel border type.' -r -f -a "none\t''
plain\t''
rounded\t''
thick\t''"
complete -c tv -n "__fish_tv_needs_command" -l preview-padding -d 'Sets the preview panel padding.' -r
complete -c tv -n "__fish_tv_needs_command" -s s -l source-command -d 'Source command to use for the current channel.' -r
complete -c tv -n "__fish_tv_needs_command" -l source-display -d 'Source display template to use for the current channel.' -r
complete -c tv -n "__fish_tv_needs_command" -l source-output -d 'Source output template to use for the current channel.' -r
complete -c tv -n "__fish_tv_needs_command" -l results-border -d 'Sets the results panel border type.' -r -f -a "none\t''
plain\t''
rounded\t''
thick\t''"
complete -c tv -n "__fish_tv_needs_command" -l results-padding -d 'Sets the results panel padding.' -r
complete -c tv -n "__fish_tv_needs_command" -l source-entry-delimiter -d 'The delimiter byte to use for splitting the source\'s command output into entries.' -r
complete -c tv -n "__fish_tv_needs_command" -s p -l preview-command -d 'Preview command to use for the current channel.' -r
complete -c tv -n "__fish_tv_needs_command" -l layout -d 'Layout orientation for the UI.' -r -f -a "landscape\t''
portrait\t''"
complete -c tv -n "__fish_tv_needs_command" -l autocomplete-prompt -d 'Try to guess the channel from the provided input prompt.' -r
complete -c tv -n "__fish_tv_needs_command" -l ui-scale -d 'Change the display size in relation to the available area.' -r
complete -c tv -n "__fish_tv_needs_command" -l preview-size -d 'Percentage of the screen to allocate to the preview panel (1-99).' -r
complete -c tv -n "__fish_tv_needs_command" -l config-file -d 'Provide a custom configuration file to use.' -r
complete -c tv -n "__fish_tv_needs_command" -l cable-dir -d 'Provide a custom cable directory to use.' -r
complete -c tv -n "__fish_tv_needs_command" -l height -d 'Height in lines for non-fullscreen mode.' -r
complete -c tv -n "__fish_tv_needs_command" -l width -d 'Width in columns for non-fullscreen mode.' -r
complete -c tv -n "__fish_tv_needs_command" -l no-preview -d 'Disable the preview panel entirely on startup.'
complete -c tv -n "__fish_tv_needs_command" -l hide-preview -d 'Hide the preview panel on startup (only works if feature is enabled).'
complete -c tv -n "__fish_tv_needs_command" -l show-preview -d 'Show the preview panel on startup (only works if feature is enabled).'
complete -c tv -n "__fish_tv_needs_command" -l no-status-bar -d 'Disable the status bar entirely on startup.'
complete -c tv -n "__fish_tv_needs_command" -l hide-status-bar -d 'Hide the status bar on startup (only works if feature is enabled).'
complete -c tv -n "__fish_tv_needs_command" -l show-status-bar -d 'Show the status bar on startup (only works if feature is enabled).'
complete -c tv -n "__fish_tv_needs_command" -l hide-preview-scrollbar -d 'Hide preview panel scrollbar.'
complete -c tv -n "__fish_tv_needs_command" -l ansi -d 'Whether tv should extract and parse ANSI style codes from the source command output.'
complete -c tv -n "__fish_tv_needs_command" -l cache-preview -d 'Whether to cache the preview command output for each entry.'
complete -c tv -n "__fish_tv_needs_command" -l exact -d 'Use substring matching instead of fuzzy matching.'
complete -c tv -n "__fish_tv_needs_command" -l select-1 -d 'Automatically select and output the first entry if there is only one entry.'
complete -c tv -n "__fish_tv_needs_command" -l take-1 -d 'Take the first entry from the list after the channel has finished loading.'
complete -c tv -n "__fish_tv_needs_command" -l take-1-fast -d 'Take the first entry from the list as soon as it becomes available.'
complete -c tv -n "__fish_tv_needs_command" -l no-remote -d 'Disable the remote control.'
complete -c tv -n "__fish_tv_needs_command" -l hide-remote -d 'Hide the remote control on startup (only works if feature is enabled).'
complete -c tv -n "__fish_tv_needs_command" -l show-remote -d 'Show the remote control on startup (only works if feature is enabled).'
complete -c tv -n "__fish_tv_needs_command" -l no-help-panel -d 'Disable the help panel entirely on startup.'
complete -c tv -n "__fish_tv_needs_command" -l hide-help-panel -d 'Hide the help panel on startup (only works if feature is enabled).'
complete -c tv -n "__fish_tv_needs_command" -l show-help-panel -d 'Show the help panel on startup (only works if feature is enabled).'
complete -c tv -n "__fish_tv_needs_command" -l global-history -d 'Use global history instead of channel-specific history.'
complete -c tv -n "__fish_tv_needs_command" -l inline -d 'Use all available empty space at the bottom of the terminal as an inline interface.'
complete -c tv -n "__fish_tv_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c tv -n "__fish_tv_needs_command" -s V -l version -d 'Print version'
complete -c tv -n "__fish_tv_needs_command" -a "list-channels" -d 'Lists the available channels'
complete -c tv -n "__fish_tv_needs_command" -a "init" -d 'Initializes shell completion ("tv init zsh")'
complete -c tv -n "__fish_tv_needs_command" -a "update-channels" -d 'Downloads the latest collection of default channel prototypes from github and saves them to the local configuration directory'
complete -c tv -n "__fish_tv_needs_command" -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c tv -n "__fish_tv_using_subcommand list-channels" -s h -l help -d 'Print help'
complete -c tv -n "__fish_tv_using_subcommand init" -s h -l help -d 'Print help'
complete -c tv -n "__fish_tv_using_subcommand update-channels" -l force -d 'Force update on already existing channels'
complete -c tv -n "__fish_tv_using_subcommand update-channels" -s h -l help -d 'Print help'
complete -c tv -n "__fish_tv_using_subcommand help; and not __fish_seen_subcommand_from list-channels init update-channels help" -f -a "list-channels" -d 'Lists the available channels'
complete -c tv -n "__fish_tv_using_subcommand help; and not __fish_seen_subcommand_from list-channels init update-channels help" -f -a "init" -d 'Initializes shell completion ("tv init zsh")'
complete -c tv -n "__fish_tv_using_subcommand help; and not __fish_seen_subcommand_from list-channels init update-channels help" -f -a "update-channels" -d 'Downloads the latest collection of default channel prototypes from github and saves them to the local configuration directory'
complete -c tv -n "__fish_tv_using_subcommand help; and not __fish_seen_subcommand_from list-channels init update-channels help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'

