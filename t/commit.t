#!/bin/bash

test_description='Commit command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_success 'commit works with no repos' \
	'$VCSH commit >output &&
	test_must_be_empty output'

# Commit is broken
test_expect_failure 'commit works with single repo' \
	'$VCSH init foo &&

	touch single &&
	$VCSH foo add single &&
	# XXX Is printing a trailing space really intended?
	echo "foo: " >expected &&
	echo ""     >>expected &&
	$VCSH commit -m "single" >output &&
	test_cmp expected output &&

	echo 1 >expected &&
	$VCSH foo rev-list HEAD --count >output &&
	test_cmp expected output'

# Commit is broken
test_expect_failure 'commit works with multiple repos' \
	'$VCSH init bar &&

	touch multi1 multi2 &&
	$VCSH foo add multi1 &&
	$VCSH bar add multi2 &&
	# XXX Is printing a trailing space and blank line really intended?
	echo "bar: "  >expected &&
	echo ""      >>expected &&
	echo "foo: " >>expected &&
	echo ""      >>expected &&
	$VCSH commit -m "multiple" >output &&
	test_cmp expected output &&

	$VCSH foo log --oneline | test_grep -x "....... multiple" &&
	$VCSH bar log --oneline | test_grep -x "....... multiple"'

# Commit is broken
test_expect_failure 'commit can handle arguments with spaces' \
	'touch msg1 msg2 &&
	$VCSH foo add msg1 &&
	$VCSH bar add msg2 &&
	$VCSH commit -m "log message" &&

	$VCSH foo log --oneline | test_grep -x "....... log message" &&
	$VCSH bar log --oneline | test_grep -x "....... log message"'

# Commit is broken
test_expect_failure 'commit works even if not all repos have changes' \
	'touch part1 part2 &&
	$VCSH foo add part1 &&
	$VCSH commit -m "part1" &&

	$VCSH bar add part2 &&
	$VCSH commit -m "part2" &&

	$VCSH foo log --oneline | test_grep -x "....... part1" &&
	$VCSH bar log --oneline | test_grep -x "....... part2"'

# Known bug
test_expect_failure 'commit not affected by existing $VCSH_COMMAND_RETURN_CODE' \
	'VCSH_COMMAND_RETURN_CODE=1 &&
	export VCSH_COMMAND_RETURN_CODE &&
	$VCSH commit'

test_done
