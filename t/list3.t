#!/bin/bash

test_description='List command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'List command displays cloned repository' \
	'$VCSH clone "$TESTREPO" test2 &&
	echo test2 >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
