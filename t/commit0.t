#!/bin/bash

test_description='Commit command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'commit works with no repos' \
	'$VCSH commit >output &&
	test_must_be_empty output'

test_done
