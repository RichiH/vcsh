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
