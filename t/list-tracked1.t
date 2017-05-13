#!/bin/bash

test_description='List-tracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'list-tracked command works with no repos and untracked files' \
	'touch a b c d e &&

	$VCSH list-tracked >output &&
	test_must_be_empty output'

test_done
