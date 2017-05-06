#!/bin/bash

test_description='Ensure init creates files with limited permissions'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

# verifies commit e220a61
test_expect_success 'Files created by init are not readable by other users' \
	'$VCSH init foo &&
	find "$HOME" -type f -perm /g+rwx,o+rwx >output &&
	test_must_be_empty output'

test_done
