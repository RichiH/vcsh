#!/bin/bash

test_description='List command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'List command displays inited repository' \
	'$VCSH init test1 &&
	echo test1 >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
