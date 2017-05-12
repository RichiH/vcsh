#!/bin/bash

test_description='Which command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Which command matches entire path' \
	'$VCSH init foo &&

	mkdir -p dir &&
	touch hello dir/testfile &&
	$VCSH foo add hello dir/testfile &&
	$VCSH foo commit -m 'dir/testfile' &&

	echo "foo: dir/testfile" >expected &&
	$VCSH which dir/testfile >output &&
	test_cmp expected output'

test_done
