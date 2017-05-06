#!/bin/bash

test_description='Clone command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone uses given remote HEAD by default' \
	'$VCSH clone "$TESTREPO" &&
	git ls-remote "$TESTREPO" HEAD | head -c40 >expected &&
	echo >>expected &&

	$VCSH run "$TESTREPONAME" git rev-parse HEAD >output &&
	test_cmp expected output'

test_done
