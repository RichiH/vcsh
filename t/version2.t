#!/bin/bash

test_description='Version command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Version can be abbreviated (versio, versi, vers, ver, ve)' \
	'$VCSH version >expected &&

	for cmd in versio versi vers ver ve; do
		$VCSH $cmd >output &&
		test_cmp expected output
	done'

test_done
