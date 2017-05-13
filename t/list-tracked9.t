#!/bin/bash

test_description='List-tracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'list-tracked accepts each repo for multiple-tracked files' \
	'$VCSH init foo &&
	$VCSH init bar &&

	touch a b &&
	$VCSH foo add a b &&
	$VCSH foo commit -m "a b" &&
	$VCSH bar add a b &&
	$VCSH bar commit -m "a b" &&

	{
		echo "$HOME/a" &&
		echo "$HOME/b"
	} >expected &&

	$VCSH list-tracked foo >output &&
	test_cmp expected output &&

	$VCSH list-tracked bar >output &&
	test_cmp expected output'

test_done
