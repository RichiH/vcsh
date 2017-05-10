#!/bin/bash

test_description='Status command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Status can be abbreviated (statu, stat, sta, st)' \
	'$VCSH init foo &&
	touch a &&
	$VCSH foo add a &&

	$VCSH status >expected &&

	for cmd in statu stat sta st; do
		$VCSH $cmd >output &&
		test_cmp expected output
	done'

test_done
