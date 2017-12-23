#!/bin/bash

test_description='Help command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_failure 'Help command succeeds' \
	'$VCSH help'

test_expect_success 'Help command writes to stderr and not stdout' \
	'$VCSH help 2>&1 1>/dev/null | test_grep "" &&
	$VCSH help 2>/dev/null | test_must_fail test_grep ""'

test_expect_success 'Help command prints usage on first line' \
	'$VCSH help 2>&1 |
		head -1 |
		test_grep "^usage: "'

test_expect_failure 'Help command can be abbreviated (hel, he)' \
	'$VCSH help >expected 2>&1 &&
	$VCSH hel >output 2>&1 &&
	test_cmp expected output &&
	$VCSH he >output 2>&1 &&
	test_cmp expected output'

# Help should explain each non-deprecated command.  (Note: adjust this if the
# format of help output changes.)
for cmd in clone commit delete enter foreach help init list list-tracked list-untracked \
		pull push rename run status upgrade version which write-gitignore; do
	test_expect_success "Help text includes $cmd command" \
		'$VCSH help 2>&1 | test_grep "^   '"$cmd"'\\b"'
done

test_done
