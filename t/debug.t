#!/bin/sh

test_description='Debug/verbose output'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_success 'Verbose output triggered by -v' \
	'$VCSH -v list 2>&1 | test_grep "list begin"'

test_expect_success 'Debug output triggered by -d' \
	'$VCSH -d list 2>&1 | test_grep "git version"'

test_done
