#!/bin/bash

test_description='List-tracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'list-tracked works with no repos' \
	'$VCSH list-tracked &>output &&
	test_must_be_empty output'

test_done