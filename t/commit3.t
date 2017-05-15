#!/bin/bash

test_description='Commit command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

# Commit is broken
test_expect_failure 'commit can handle arguments with spaces' \
	'$VCSH init foo &&
	$VCSH init bar &&

	touch a b &&
	$VCSH foo add a &&
	$VCSH bar add b &&
	$VCSH commit -m "log message" &&

	$VCSH foo log --oneline | assert_grep -x "....... log message" &&
	$VCSH bar log --oneline | assert_grep -x "....... log message"'

test_done
