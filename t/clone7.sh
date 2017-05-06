#!/bin/bash

test_description='Clone command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

@test "Clone honors -b option after remote" {
	$VCSH clone "$TESTREPO" -b "$TESTBR1" &&
	output="$(git ls-remote "$TESTREPO" "$TESTBR1")" &&
	correct=${output::40} &&

	output="$($VCSH run "$TESTREPONAME" git rev-parse "$TESTBR1")" &&
	assert "$output" = "$correct"'

test_done
