#!/bin/sh

test_description='Configuration files'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_success 'File given with -c is sourced' \
	'echo "echo _SUCCESS_" >config &&
	$VCSH -c "$PWD/config" list | test_grep _SUCCESS_'

test_expect_success 'Relative path works with -c' \
	'echo "echo _SUCCESS_" >config &&
	$VCSH -c config list | test_grep _SUCCESS_'

test_expect_failure 'Command-line options take priority over config files' \
	'echo "VCSH_VERBOSE=0" >config &&
	$VCSH -v -c "$PWD/config" list 2>&1 | test_grep "list begin"'

test_done
