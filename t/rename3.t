#!/bin/bash

test_description='Rename command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Rename works on empty repository' \
	'$VCSH init foo &&
	$VCSH rename foo bar &&

	echo bar >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
