# run git command
#   based on bash_completion:_command_offset()
_vcsh_git_command () {
	local word_offset=$1
	for (( i=0; i < word_offset; i++ )); do
		for (( j=0; j <= ${#COMP_LINE}; j++ )); do
			[[ "$COMP_LINE" == "${COMP_WORDS[i]}"* ]] && break
			COMP_LINE=${COMP_LINE:1}
			((COMP_POINT--))
		done
		COMP_LINE=${COMP_LINE#"${COMP_WORDS[i]}"}
		((COMP_POINT-=${#COMP_WORDS[i]}))
	done
	COMP_LINE="git $COMP_LINE"
	((COMP_POINT+=4))

	# shift COMP_WORDS elements and adjust COMP_CWORD
	for (( i=1; i <= COMP_CWORD - word_offset + 1; i++ )); do
		COMP_WORDS[i]=${COMP_WORDS[i+$word_offset-1]}
	done
	for (( i; i <= COMP_CWORD; i++ )); do
		unset 'COMP_WORDS[i]'
	done
	COMP_WORDS[0]=git
	((COMP_CWORD -= word_offset - 1))

	local cspec
	cspec=$( complete -p git 2>/dev/null )
	if [[ -z $cspec ]]; then
		if declare -F __load_completion &> /dev/null; then
			__load_completion git
			cspec=$( complete -p git 2>/dev/null )
		fi
	fi
	if [[ -n $cspec ]]; then
		if [[ ${cspec#* -F } != $cspec ]]; then
			local func=${cspec#*-F }
			func=${func%% *}

			if [[ ${#COMP_WORDS[@]} -ge 2 ]]; then
				$func git "${COMP_WORDS[${#COMP_WORDS[@]}-1]}" "${COMP_WORDS[${#COMP_WORDS[@]}-2]}"
			else
				$func git "${COMP_WORDS[${#COMP_WORDS[@]}-1]}"
			fi

			# restore initial compopts
			local opt
			while [[ $cspec == *" -o "* ]]; do
				# FIXME: should we take "+o opt" into account?
				cspec=${cspec#*-o }
				opt=${cspec%% *}
				compopt -o $opt
				cspec=${cspec#$opt}
			done
		fi
	fi
}

_vcsh () {
	local cur prev words OPTS
	_init_completion -n = || return

	local r reponames
	local -A repos
	mapfile -t reponames < <(command vcsh list)
	for r in "${reponames[@]}"; do repos["$r"]="$r"; done
	unset r reponames
	local cmds
	cmds="clone delete enter foreach help init commit list list-tracked list-untracked pull push rename run status upgrade version which write-gitignore"

	local subcword cmd subcmd
	for (( subcword=1; subcword < ${#words[@]}-1; subcword++ )); do
		[[ -n $cmd && ${words[subcword]} != -* ]] && subcmd=${words[subcword]} && break
		[[ ${words[subcword]} != -* ]] && cmd=${words[subcword]}
	done

	if [[ -z $cmd ]]; then
		case $prev in
			-c)
				mapfile -t COMPREPLY < <(compgen -f -- "$cur")
				return
				;;
		esac

		case $cur in
			-*)
				OPTS='-c -d -h -v'
				mapfile -t COMPREPLY < <(compgen -W "$OPTS" -- "$cur")
				return
				;;
		esac
		mapfile -t COMPREPLY < <(compgen -W "${repos[*]} ${cmds}" -- "$cur")
		return 0
	fi

	case $cmd in
		help|init|commit|list|pull|push|version|which)
			return
			;;

		list-untracked)
			[[ $cur == -* ]] && \
				mapfile -t COMPREPLY < <(compgen -W '-a -r' -- "$cur") && return
			;;&

		run)
			if [[ -n $subcmd && -n "${repos[$subcmd]}" ]]; then
				_command_offset $(( subcword+1 ))
				return
			fi
			;;&

		delete|enter|list-tracked|list-untracked|rename|run|status|upgrade|write-gitignore)
			# return repos
			if [[ -z $subcmd ]]; then
				mapfile -t COMPREPLY < <(compgen -W "${repos[*]}" -- "$cur")
				return
			fi
			return
			;;

		clone)
			[[ $cur == -* ]] && \
				mapfile -t COMPREPLY < <(compgen -W '-b' -- "$cur")
			return
			;;

		foreach)
			[[ $cur == -* ]] \
				&& mapfile -t COMPREPLY < <(compgen -W "-g" -- "$cur") && return
			_vcsh_git_command $subcword
			return
			;;

	esac

	# git command on repository
	if [[ -n "${repos[$cmd]}" ]]; then
		: "${VCSH_REPO_D:=${XDG_CONFIG_HOME:-$HOME/.config}/vcsh/repo.d}"
		GIT_DIR="${VCSH_REPO_D}/${cmd}.git" _vcsh_git_command "$subcword"
	fi
	return 0
}

complete -F _vcsh vcsh
