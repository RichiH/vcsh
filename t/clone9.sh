#!/bin/bash

test_description='Clone command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone honors -b option after repo name' \
	'$VCSH clone "$TESTREPO" foo -b "$TESTBR1" &&
	output="$(git ls-remote "$TESTREPO" "$TESTBR1")" &&
	correct=${output::40} &&

	output="$($VCSH run foo git rev-parse "$TESTBR1")" &&
	assert "$output" = "$correct"'

test_done
