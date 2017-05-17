#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_failure 'pull fails if first pull fails' \
	'test_create_repo repo1 &&
	test_create_repo repo2 &&
	test_commit -C repo1 A &&
	test_commit -C repo2 B &&
	$VCSH clone ./repo1 a &&
	$VCSH clone ./repo2 b &&

	rm -rf repo1 &&
	test_commit -C repo2 X &&

	test_must_fail $VCSH pull'

test_done
