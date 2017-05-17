#!/bin/bash

test_description='Clone command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone honors specified repo name' \
	'test_create_repo repo &&
	test_commit -C repo A &&

	$VCSH clone ./repo foo &&
	echo foo >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
