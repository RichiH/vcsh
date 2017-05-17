#!/bin/bash

test_description='Foreach command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Foreach executes Git command inside each repository' \
	'test_create_repo repo1 &&
	test_commit -C repo1 A &&
	test_create_repo repo2 &&
	test_commit -C repo2 B &&
	$VCSH clone ./repo1 foo &&
	$VCSH clone ./repo2 bar &&

	{
		echo "bar:" &&
		git -C repo2 rev-parse HEAD &&
		echo "foo:" &&
		git -C repo1 rev-parse HEAD
	} >expected &&

	$VCSH foreach rev-parse HEAD >output &&
	test_cmp expected output'

test_done
