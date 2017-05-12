#!/bin/bash

test_description='Foreach command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Foreach does nothing if no repositories exist' \
	'$VCSH foreach version >output &&
	test_must_be_empty output'

test_done
