#!/bin/bash

test_description='Clone command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone uses existing repo name by default' \
	'$VCSH clone "$TESTREPO" &&
	echo "$TESTREPONAME" >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
