#!/bin/bash

test_description='List-tracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'list-tracked orders files by path' \
	'$VCSH init foo &&
	$VCSH init bar &&

	touch a b c d e &&
	$VCSH foo add a d &&
	$VCSH foo commit -m "a d" &&
	$VCSH bar add b e &&
	$VCSH bar commit -m "b e" &&

	{
		echo "$HOME/a" &&
		echo "$HOME/b" &&
		echo "$HOME/d" &&
		echo "$HOME/e"
	} >expected &&
	$VCSH list-tracked >output &&
	test_cmp expected output'

test_done
