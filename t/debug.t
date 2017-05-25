#!/bin/bash

test_description='Debug mode'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

# XXX add more?
test_expect_success 'Debug output includes git version' \
	'$VCSH -d init foo |& test_grep "git version [0-9]" &&
	$VCSH -d list |& test_grep "git version [0-9]"'

test_done
