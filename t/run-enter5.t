#!/bin/bash

test_description='Run/enter commands'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Enter executes $SHELL inside repository' \
	'$VCSH clone -b "$TESTBR1" "$TESTREPO" foo &&

	git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1 >expected &&
	SHELL="git rev-parse HEAD" $VCSH enter foo >output &&
	test_cmp expected output'

test_done
