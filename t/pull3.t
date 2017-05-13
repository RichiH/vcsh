#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'pull works with multiple repositories' \
	'git clone -b "$TESTBR1" "$TESTREPO" upstream1 &&
	git clone -b "$TESTBR2" "$TESTREPO" upstream2 &&

	$VCSH clone -b "$TESTBR1" upstream1 foo &&
	$VCSH clone -b "$TESTBR2" upstream2 bar &&

	git -C upstream1 commit --allow-empty -m "empty" &&
	git -C upstream1 rev-parse HEAD >expected &&

	$VCSH pull &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output &&

	git -C upstream2 commit --allow-empty -m "empty2" &&
	git -C upstream2 rev-parse HEAD >expected &&

	$VCSH pull &&
	$VCSH bar rev-parse HEAD >output &&
	test_cmp expected output'

test_done
