#!/bin/bash

test_description='List command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'List command displays cloned repository' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	test_commit -C repo B &&

	$VCSH clone ./repo foo &&
	echo foo >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
