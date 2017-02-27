setup() {
	export VCSH="$BATS_TEST_DIRNAME/../vcsh"
	export LC_ALL=C

	# XXX Currently the /etc/vcsh/config file can affect testcases.
	# Perhaps it should be ignored if one exists in $XDG_CONFIG_HOME or was
	# specified with -c?

	# Test repository.  For faster tests, you can create a local mirror and
	# use that instead.
	: ${TESTREPO:='https://github.com/djpohly/vcsh_testrepo.git'}
	: ${TESTREPONAME:='vcsh_testrepo'}
	export TESTREPO TESTREPONAME
	export TESTM1=master
	export TESTM2=master2
	export TESTBR1=branch1
	export TESTBR2=branch2
	export TESTBRX=conflict

	# Other things used in tests
	export GITVERSION=$(git version)

	# Clear out environment variables that affect VCSH behavior
	unset VCSH_OPTION_CONFIG VCSH_REPO_D VCSH_HOOK_D VCSH_OVERLAY_D
	unset VCSH_BASE VCSH_GITIGNORE VCSH_GITATTRIBUTES VCSH_WORKTREE
	unset XDG_CONFIG_HOME

	# Make a directory for testing and make it $HOME
	export BATS_TESTDIR=$(mktemp -d -p "$BATS_TMPDIR")
	export HOME=$BATS_TESTDIR
	cd

	# Clear out variables that affect Git behavior
	unset EDITOR VISUAL GIT_EDITOR

	# Set a few Git variables
	GIT_AUTHOR_NAME='A U Thor'
	GIT_AUTHOR_EMAIL='author@example.com'
	GIT_COMMITTER_NAME='C O Mitter'
	GIT_COMMITTER_EMAIL='committer@example.com'
	GIT_MERGE_VERBOSITY=5
	GIT_MERGE_AUTOEDIT=no
	export GIT_{AUTHOR,COMMITTER}_{NAME,EMAIL}
	export GIT_MERGE_{VERBOSITY,AUTOEDIT}
}

teardown() {
	# Don't saw off the branch you're sitting on
	cd /

	# Make sure removal will succeed even if we have altered permissions
	chmod -R a+rwx "$BATS_TESTDIR"
	rm -rf "$BATS_TESTDIR"
}

num_gitrepos() {
	# Prints the number of apparent Git repositories below $1
	find "$1" -mindepth 1 -type d -name '*.git' | wc -l
}

assert() {
	if [ $# -ne 3 ]; then
		echo 'assert: requires three arguments (forgot to quote?)' >&2
		return 2
	fi

	if ! test "$@"; then
		echo "assertion \"$2\" failed" >&2
		echo "actual   : \"$1\"" >&2
		echo "reference: \"$3\"" >&2
		return 1
	fi
}

assert_file() {
	negate=
	if [ "$1" = "!" ]; then
		if [ $# -ne 3 ]; then
			echo 'assert_file: requires two arguments after ! (forgot to quote?)' >&2
			return 2
		fi
		negate='! '
		shift
	elif [ $# -ne 2 ]; then
		echo 'assert_file: requires two arguments (forgot to quote?)' >&2
		return 2
	fi

	if ! test $negate "$@"; then
		echo "assertion \"$negate$1\" failed" >&2
		echo "file: \"$2\"" >&2
		return 1
	fi
}
