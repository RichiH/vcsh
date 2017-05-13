#!/bin/bash

test_description='List-tracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'list-tracked lists files from one repo' \
	'$VCSH init foo &&

	touch a b c d e &&
	$VCSH foo add a d &&
	$VCSH foo commit -m "a d" &&

	{
		echo "$HOME/a" &&
		echo "$HOME/d"
	} >expected &&
	$VCSH list-tracked >output &&
	test_cmp expected output'

test_done
