#!/bin/bash

test_description='Clone command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone uses given remote HEAD by default' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	$VCSH clone ./repo foo &&

	git -C repo rev-parse HEAD >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output'

test_done
