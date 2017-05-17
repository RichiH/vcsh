#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'pull works with multiple repositories' \
	'test_create_repo repo1 &&
	test_create_repo repo2 &&
	test_commit -C repo1 A &&
	test_commit -C repo2 B &&
	$VCSH clone ./repo1 foo &&
	$VCSH clone ./repo2 bar &&

	test_commit -C repo1 X &&
	git -C repo1 rev-parse HEAD >expected &&

	$VCSH pull &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output &&

	test_commit -C repo2 Y &&
	git -C repo2 rev-parse HEAD >expected &&

	$VCSH pull &&
	$VCSH bar rev-parse HEAD >output &&
	test_cmp expected output'

test_done
