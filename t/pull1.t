#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'pull succeeds if up-to-date' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	$VCSH clone ./repo foo &&

	echo -e "foo: Already up-to-date.\\n" >expected &&
	$VCSH pull >output &&
	test_cmp expected output'

test_done
