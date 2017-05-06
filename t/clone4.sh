#!/bin/bash

test_description='Clone command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone uses given remote HEAD by default' \
	'$VCSH clone "$TESTREPO" &&
	output="$(git ls-remote "$TESTREPO" HEAD)" &&
	correct=${output::40} &&

	output="$($VCSH run "$TESTREPONAME" git rev-parse HEAD)" &&
	assert "$output" = "$correct"'

test_done
