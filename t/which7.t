#!/bin/bash

test_description='Which command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Which command matches directory path component' \
	'$VCSH init foo &&

	mkdir -p dir/subd &&
	touch hello dir/subd/testfile &&
	$VCSH foo add hello dir/subd/testfile &&
	$VCSH foo commit -m "dir/subd/testfile" &&

	echo "foo: dir/subd/testfile" >expected &&
	$VCSH which subd >output &&
	test_cmp expected output'

test_done