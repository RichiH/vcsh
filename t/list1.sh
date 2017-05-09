#!/bin/bash

test_description='List command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'List command correct for no repositories' \
	'$VCSH list >output &&
	test_must_be_empty output'

test_done
