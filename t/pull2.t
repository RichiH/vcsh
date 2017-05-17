#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'pull works with one repository' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	$VCSH clone ./repo foo &&

	test_commit -C repo B &&
	git -C repo rev-parse HEAD >expected &&

	$VCSH pull &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output'

test_done
