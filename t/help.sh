#!/bin/bash

test_description='Help command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_failure 'Help command succeeds' \
	'$VCSH help'

test_expect_success 'Help command writes to stderr and not stdout' \
	'$VCSH help 2>&1 1>/dev/null | assert_grep "" &&
	! $VCSH help 2>/dev/null | assert_grep ""'

test_expect_success 'Help command prints usage on first line' \
	'$VCSH help |&
		head -1 |
		assert_grep "^usage: "'

test_expect_failure 'Help command can be abbreviated (hel, he)' \
	'good="$($VCSH help 2>&1)" &&
	output1=$($VCSH hel 2>&1)" &&
	assert "$output1" = "$good" &&
	output2=$($VCSH he 2>&1)" &&
	assert "$output2" = "$good"'

# Help should explain each non-deprecated command.  (Note: adjust this if the
# format of help output changes.)
for cmd in clone commit delete enter foreach help init list list-tracked list-untracked \
		pull push rename run status upgrade version which write-gitignore; do
	test_expect_success "Help text includes $cmd command" \
		'$VCSH help 2>&1 | assert_grep "^   '"$cmd"'\\b"'
done

test_done
