#!/bin/bash

test_description='List command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'List command respects $HOME' \
	'test_env HOME="$PWD/foo" $VCSH init test1 &&
	test_env HOME="$PWD/bar" $VCSH init test2 &&

	echo test1 >expected &&
	test_env HOME="$PWD/foo" $VCSH list >output &&
	test_cmp expected output &&

	echo test2 >expected &&
	test_env HOME="$PWD/bar" $VCSH list >output &&
	test_cmp expected output'

test_done
