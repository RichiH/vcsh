# Command to run for vcsh (test-lib will put build dir at the head of PATH)
# To test other shells, run with VCSH="dash vcsh", VCSH="zsh vcsh", etc.
: "${VCSH:=vcsh}"
export VCSH

# XXX Currently the /etc/vcsh/config file can affect testcases.
# Perhaps it should be ignored if one exists in $XDG_CONFIG_HOME or was
# specified with -c?

# Clear out environment variables that affect VCSH behavior
unset VCSH_OPTION_CONFIG VCSH_REPO_D VCSH_HOOK_D VCSH_OVERLAY_D
unset VCSH_BASE VCSH_GITIGNORE VCSH_GITATTRIBUTES VCSH_WORKTREE

find_gitrepos() {
	# Prints apparent Git repositories below $1
	find "$1" -mindepth 1 -type d -name '*.git'
}

num_gitrepos() {
	find_gitrepos "$@" | wc -l
}

# Similar to grep -q, but prints the entire input to stderr for debugging
test_grep() {
	tee /dev/stderr 2>&3 | grep "$@" > /dev/null
}

# For delete testing
doit() {
	echo "Yes, do as I say"
}

vcsh_temp_repo() {
	$VCSH init "$1" &&
	test_when_finished "doit | \$VCSH delete \"$1\""
}

vcsh_temp_clone() {
	$VCSH clone "$1" "$2" &&
	test_when_finished "doit | \$VCSH delete \"$2\""
}
