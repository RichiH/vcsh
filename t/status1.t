#!/bin/bash

test_description='Status command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Status command correct for no repos' \
	'$VCSH status >output &&
	test_must_be_empty output'

test_done
