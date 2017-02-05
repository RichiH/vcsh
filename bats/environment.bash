setup() {
	VCSH="$BATS_TEST_DIRNAME/../vcsh"
	export LC_ALL=C

	# Test repository.  For faster tests, you can create a local mirror and
	# use that instead.
	: ${TESTREPO:='https://github.com/djpohly/vcsh_testrepo.git'}
	: ${TESTREPONAME:='vcsh_testrepo'}
	TESTM1=master
	TESTM2=master2
	TESTBR1=branch1
	TESTBR2=branch2
	TESTBRX=conflict

	# Other things used in tests
	GITVERSION=$(git version)

	BATS_TESTDIR=$(mktemp -d -p "$BATS_TMPDIR")
	export HOME=$BATS_TESTDIR
	export XDG_CONFIG_HOME=$HOME/.config
	cd
}

teardown() {
	# Don't saw off the branch you're sitting on
	cd /

	# Make sure removal will succeed even if we have altered permissions
	chmod -R a+rwx "$BATS_TESTDIR"
	rm -rf "$BATS_TESTDIR"
}

is_git_repo() {
	test -d "$1"

	cd "$1"
	test -f HEAD
	test -f config
	test -f description
	test -d hooks
	test -d info
	test -d objects
	test -d refs

	test -f hooks/applypatch-msg.sample
	test -f hooks/commit-msg.sample
	test -f hooks/post-update.sample
	test -f hooks/pre-applypatch.sample
	test -f hooks/pre-commit.sample
	test -f hooks/pre-push.sample
	test -f hooks/pre-rebase.sample
	test -f hooks/prepare-commit-msg.sample
	test -f hooks/update.sample

	test -f info/exclude

	test -d objects/info
	test -d objects/pack

	test -d refs/heads
	test -d refs/tags
}
