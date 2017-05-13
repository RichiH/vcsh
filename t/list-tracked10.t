#!/bin/bash

test_description='List-tracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'list-tracked-by requires an argument' \
	'test_must_fail $VCSH list-tracked-by'

test_done
