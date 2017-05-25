#!/bin/bash

test_description='List-untracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_success 'list-untracked works with no repos' \
	'$VCSH list-untracked &>output &&
	test_must_be_empty output'

test_done
