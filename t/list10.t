#!/bin/bash

test_description='List command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'List command respects $VCSH_REPO_D' \
	'test_env VCSH_REPO_D="$PWD/foo" $VCSH init test1 &&
	test_env VCSH_REPO_D="$PWD/bar" $VCSH init test2 &&

	echo test1 >expected &&
	test_env VCSH_REPO_D="$PWD/foo" $VCSH list >output &&
	test_cmp expected output &&

	echo test2 >expected &&
	test_env VCSH_REPO_D="$PWD/bar" $VCSH list >output &&
	test_cmp expected output'

test_done
