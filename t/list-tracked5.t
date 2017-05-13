#!/bin/bash

test_description='List-tracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'list-tracked lists files from two repos' \
	'$VCSH init foo &&
	$VCSH init bar &&

	touch a b c d e &&
	$VCSH foo add a b &&
	$VCSH foo commit -m "a b" &&
	$VCSH bar add c d &&
	$VCSH bar commit -m "c d" &&

	{
		echo "$HOME/a" &&
		echo "$HOME/b" &&
		echo "$HOME/c" &&
		echo "$HOME/d"
	} >expected &&
	$VCSH list-tracked >output &&
	test_cmp expected output'

test_done
