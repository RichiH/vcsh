#!/bin/bash

test_description='Clone command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone honors -b option after remote' \
	'$VCSH clone "$TESTREPO" -b "$TESTBR1" &&
	git ls-remote "$TESTREPO" "$TESTBR1" | head -c40 >expected &&
	echo >>expected &&

	$VCSH run "$TESTREPONAME" git rev-parse "$TESTBR1" >output &&
	test_cmp expected output'

test_done
