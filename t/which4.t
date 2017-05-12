#!/bin/bash

test_description='Which command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Which command matches exact filename' \
	'$VCSH init foo &&

	touch hello testfile &&
	$VCSH foo add hello testfile &&
	$VCSH foo commit -m "testfile" &&

	echo "foo: testfile" >expected &&
	$VCSH which testfile >output &&
	test_cmp expected output'

test_done
