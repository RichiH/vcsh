#!/bin/bash

test_description='Delete command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Delete requires confirmation' \
	'$VCSH init foo &&
	echo foo >expected &&

	test_must_fail $VCSH delete foo < /dev/null &&
	$VCSH list >output &&
	test_cmp expected output &&

	echo | test_must_fail $VCSH delete foo &&
	$VCSH list >output &&
	test_cmp expected output &&

	echo no | test_must_fail $VCSH delete foo &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
