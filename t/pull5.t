#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'pull fails if last pull fails' \
	'test_create_repo repo1 &&
	test_create_repo repo2 &&
	test_commit -C repo1 A &&
	test_commit -C repo2 B &&
	$VCSH clone ./repo1 a &&
	$VCSH clone ./repo2 b &&

	test_commit -C repo1 X &&
	rm -rf repo2 &&

	test_must_fail $VCSH pull'

test_done
