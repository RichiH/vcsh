#!/bin/bash

test_description='Status command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Status command correct for empty repo' \
	'$VCSH init foo &&

	echo "foo:"  >expected &&
	echo ""     >>expected &&
	$VCSH status >output &&
	test_cmp expected output'

test_done
