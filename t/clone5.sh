#!/bin/bash

test_description='Clone command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone honors -b option before remote' \
	'$VCSH clone -b "$TESTBR1" "$TESTREPO" &&
	output="$(git ls-remote "$TESTREPO" "$TESTBR1")" &&
	correct=${output::40} &&

	output="$($VCSH run "$TESTREPONAME" git rev-parse "$TESTBR1")" &&
	assert "$output" = "$correct"'

test_done
