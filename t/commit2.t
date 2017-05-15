#!/bin/bash

test_description='Commit command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

# Commit is broken
test_expect_failure 'commit works with multiple repos' \
	'$VCSH init foo &&
	$VCSH init bar &&

	touch a b &&
	$VCSH foo add a &&
	$VCSH bar add b &&
	# XXX Is printing a trailing space and blank line really intended?
	echo "bar: "  >expected &&
	echo ""      >>expected &&
	echo "foo: " >>expected &&
	echo ""      >>expected &&
	$VCSH commit -m "ab" >output &&
	test_cmp expected output &&

	$VCSH foo log --oneline | assert_grep -x "....... ab" &&
	$VCSH bar log --oneline | assert_grep -x "....... ab"'

test_done
