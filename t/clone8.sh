#!/bin/bash

test_description='Clone command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone honors -b option between remote and repo name' \
	'$VCSH clone "$TESTREPO" -b "$TESTBR1" foo &&
	output="$(git ls-remote "$TESTREPO" "$TESTBR1")" &&
	correct=${output::40} &&

	output="$($VCSH run foo git rev-parse "$TESTBR1")" &&
	assert "$output" = "$correct"'

test_done
