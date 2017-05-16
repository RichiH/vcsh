#!/bin/bash

test_description='Rename command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Rename works on repository with files/commits' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	test_commit -C repo B &&
	git -C repo rev-parse HEAD >expected &&

	$VCSH clone ./repo foo &&
	$VCSH rename foo bar &&
	$VCSH bar rev-parse HEAD >output &&
	test_cmp expected output'

test_done
