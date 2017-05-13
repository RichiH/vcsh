#!/bin/bash

test_description='List-tracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_failure 'list-tracked fails if argument is not a repo' \
	'test_must_fail $VCSH list-tracked nope'

test_done
