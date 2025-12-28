#!/bin/sh

test_description='Version command'

. ./sharness/sharness.sh
. "$SHARNESS_TEST_DIRECTORY/environment.sh"

test_expect_success 'Version command succeeds' \
	'$VCSH version'

test_expect_success 'Version command prints vcsh and git versions' \
	'$VCSH version >output &&
	sed -n 1p output | test_grep "^vcsh [0-9]" &&
	sed -n 2p output | test_grep "^git version [0-9]"'

test_expect_success 'Version can be abbreviated (versio, versi, vers, ver, ve)' \
	'$VCSH version >expected &&

	for cmd in versio versi vers ver ve; do
		$VCSH $cmd >output &&
		test_cmp expected output
	done'

test_done
