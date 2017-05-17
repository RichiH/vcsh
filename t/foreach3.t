#!/bin/bash

test_description='Foreach command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Foreach supports -g for non-Git commands' \
	'test_create_repo repo1 &&
	test_commit -C repo1 A &&
	test_create_repo repo2 &&
	test_commit -C repo2 B &&
	$VCSH clone ./repo1 foo &&
	$VCSH clone ./repo2 bar &&

	{
		echo "bar:" &&
		echo "test-output" &&
		echo "foo:" &&
		echo "test-output"
	} >expected &&

	$VCSH foreach -g echo test-output >output &&
	test_cmp expected output'

test_done
