#!/bin/bash

test_description='Commit command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

# Commit is broken
test_expect_failure 'commit works with single repo' \
	'$VCSH init foo &&

	touch a &&
	$VCSH foo add a &&
	# XXX Is printing a trailing space really intended?
	echo "foo: " >expected &&
	$VCSH commit -m a >output &&
	test_cmp expected output &&

	echo 1 >expected &&
	$VCSH foo rev-list HEAD --count >output &&
	test_cmp expected output'

test_done
