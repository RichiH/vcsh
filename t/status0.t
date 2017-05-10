#!/bin/bash

test_description='Status command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Status argument if any must be a repo' \
	'test_must_fail $VCSH status nope'

test_done
