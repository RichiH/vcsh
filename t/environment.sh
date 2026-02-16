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

# Set Git environment variables
GIT_AUTHOR_EMAIL=author@example.com
GIT_AUTHOR_NAME='A U Thor'
GIT_COMMITTER_EMAIL=committer@example.com
GIT_COMMITTER_NAME='C O Mitter'
GIT_MERGE_VERBOSITY=5
GIT_MERGE_AUTOEDIT=no
GIT_ADVICE=0
export GIT_MERGE_VERBOSITY GIT_MERGE_AUTOEDIT
export GIT_AUTHOR_EMAIL GIT_AUTHOR_NAME
export GIT_COMMITTER_EMAIL GIT_COMMITTER_NAME
export GIT_ADVICE

. "$SHARNESS_TEST_DIRECTORY"/git-functions.sh

find_gitrepos() {
	# Prints apparent Git repositories below $1
	find "$1" -mindepth 1 -type d -name '*.git'
}

num_gitrepos() {
	find_gitrepos "$@" | wc -l
}

test_setup() {
	desc=$1
	shift
	test_expect_success "[setup] $desc" "$@"
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
	for repo; do
		$VCSH init "$repo" &&
		test_when_finished "doit | \$VCSH delete \"$repo\"" || return 1
	done
}

vcsh_temp_clone() {
	$VCSH clone "$1" "$2" &&
	test_when_finished "doit | \$VCSH delete \"$2\"" || return 1
}
