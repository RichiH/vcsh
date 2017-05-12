#!/bin/bash

test_description='Run/enter commands'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Enter implied for single non-command argument' \
	'$VCSH clone -b "$TESTBR1" "$TESTREPO" foo &&
	$VCSH clone -b "$TESTBR2" "$TESTREPO" bar &&

	git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1 >expected &&
	echo "git rev-parse HEAD" | test_env SHELL=/bin/sh $VCSH foo >output &&
	test_cmp expected output &&

	git ls-remote "$TESTREPO" "refs/heads/$TESTBR2" | cut -f 1 >expected &&
	echo "git rev-parse HEAD" | test_env SHELL=/bin/sh $VCSH bar >output &&
	test_cmp expected output'

test_done
