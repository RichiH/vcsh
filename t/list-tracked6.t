#!/bin/bash

test_description='List-tracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'list-tracked lists files from specified repo' \
	'$VCSH init foo &&
	$VCSH init bar &&

	touch a b c d e &&
	$VCSH foo add a b &&
	$VCSH foo commit -m "a b" &&
	$VCSH bar add c d &&
	$VCSH bar commit -m "c d" &&

	{
		echo "$HOME/a" &&
		echo "$HOME/b"
	} >expected &&
	$VCSH list-tracked foo >output &&
	test_cmp expected output &&

	{
		echo "$HOME/c" &&
		echo "$HOME/d"
	} >expected &&
	$VCSH list-tracked bar >output &&
	test_cmp expected output'

test_done
