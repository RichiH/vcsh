#!/bin/bash

test_description='Clone command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone can be abbreviated (clon, clo, cl)' \
	'$VCSH clon "$TESTREPO" a &&
	$VCSH clo -b "$TESTBR1" "$TESTREPO" b &&
	$VCSH cl -b "$TESTBR2" "$TESTREPO" c &&

	output="$($VCSH list)" &&
	assert "$output" = "$(printf '\''a\nb\nc'\'')"'

test_done
