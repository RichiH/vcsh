#!/bin/bash

test_description='Clone command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone honors -b option after remote' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	git -C repo checkout -b branchb &&
	test_commit -C repo B &&
	git -C repo checkout master &&

	$VCSH clone ./repo -b branchb &&
	git -C repo rev-parse branchb >expected &&
	$VCSH repo rev-parse HEAD >output &&
	test_cmp expected output'

test_done
