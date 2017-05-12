#!/bin/bash

test_description='Commit command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

# Commit is broken
test_expect_failure 'commit works even if not all repos have changes' \
	'$VCSH init foo &&
	$VCSH init bar &&

	touch a b &&
	$VCSH foo add a &&
	$VCSH commit -m "part1" &&

	$VCSH bar add b &&
	$VCSH commit -m "part2" &&

	$VCSH foo log --oneline | assert_grep -x "....... part1" &&
	$VCSH bar log --oneline | assert_grep -x "....... part2"'

test_done
