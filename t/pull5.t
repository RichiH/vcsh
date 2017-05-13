#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'pull fails if last pull fails' \
	'git clone -b "$TESTBR1" "$TESTREPO" upstream1 &&
	git clone -b "$TESTBR2" "$TESTREPO" upstream2 &&

	$VCSH clone -b "$TESTBR1" upstream1 a &&
	$VCSH clone -b "$TESTBR2" upstream2 b &&

	git -C upstream1 commit --allow-empty -m "empty" &&
	rm -rf upstream2 &&

	test_must_fail $VCSH pull'

test_done
