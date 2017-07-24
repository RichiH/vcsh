#!/bin/bash

test_description='Foreach command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_success 'Foreach requires an argument' \
	'test_must_fail $VCSH foreach'

test_expect_success 'Foreach does nothing if no repositories exist' \
	'$VCSH foreach version >output &&
	test_must_be_empty output'

test_setup 'Create two repositories' \
	'test_create_repo repo1 &&
	test_commit -C repo1 A &&
	test_create_repo repo2 &&
	test_commit -C repo2 B &&
	$VCSH clone ./repo1 foo &&
	$VCSH clone ./repo2 bar'

test_expect_success 'Foreach executes Git command inside each repository' \
	'{
		echo "bar:" &&
		git -C repo2 rev-parse HEAD &&
		echo "foo:" &&
		git -C repo1 rev-parse HEAD
	} >expected &&

	$VCSH foreach rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Foreach supports -g for non-Git commands' \
	'{
		echo "bar:" &&
		echo "test-output" &&
		echo "foo:" &&
		echo "test-output"
	} >expected &&

	$VCSH foreach -g echo test-output >output &&
	test_cmp expected output'

test_done
