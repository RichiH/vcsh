#!/bin/bash

test_description='Clone command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone -b option clones only one branch' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	git -C repo checkout -b branchb &&
	test_commit -C repo B &&
	git -C repo checkout master &&

	$VCSH clone -b branchb ./repo foo &&
	$VCSH foo show-ref --heads >output &&
	test_line_count = 1 output'

test_done
