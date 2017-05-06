#!/bin/bash

test_description='Clone command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone uses existing repo name by default' \
	'$VCSH clone "$TESTREPO" &&
	$VCSH list &&
	output="$($VCSH list)" &&
	assert "$output" = "$TESTREPONAME"

test_done
