#!/bin/bash

test_description='List-tracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'list-tracked works with no repos' \
	'$VCSH list-tracked &>output &&
	test_must_be_empty output'

test_expect_success 'list-tracked command works with no repos and untracked files' \
	'touch a b c d e &&

	$VCSH list-tracked >output &&
	test_must_be_empty output'

test_expect_failure 'list-tracked fails if argument is not a repo' \
	'test_must_fail $VCSH list-tracked nope'

test_expect_success 'list-tracked works on empty repo' \
	'$VCSH init foo &&
	$VCSH list-tracked >output &&
	test_must_be_empty output'

test_expect_success 'list-tracked works on specified empty repo' \
	'$VCSH list-tracked foo >output &&
	test_must_be_empty output'

test_expect_success 'list-tracked lists files from one repo' \
	'$VCSH foo add a d &&
	$VCSH foo commit -m "a d" &&

	{
		echo "$HOME/a" &&
		echo "$HOME/d"
	} >expected &&
	$VCSH list-tracked >output &&
	test_cmp expected output'

test_expect_success 'list-tracked lists files from two repos' \
	'$VCSH init bar &&

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

test_expect_success 'list-tracked lists files from specified repo' \
	'{
		echo "$HOME/a" &&
		echo "$HOME/d"
	} >expected &&
	$VCSH list-tracked foo >output &&
	test_cmp expected output &&

	{
		echo "$HOME/b" &&
		echo "$HOME/e"
	} >expected &&
	$VCSH list-tracked bar >output &&
	test_cmp expected output'

test_expect_success 'list-tracked does not repeat multiple-tracked files' \
	'rev=$($VCSH bar rev-parse HEAD) &&
	$VCSH bar add a &&
	$VCSH bar commit -m "a" &&

	{
		echo "$HOME/a" &&
		echo "$HOME/b" &&
		echo "$HOME/d" &&
		echo "$HOME/e"
	} >expected &&
	$VCSH list-tracked >output &&
	test_cmp expected output &&
	
	$VCSH bar reset --hard "$rev"'

test_expect_success 'list-tracked-by requires an argument' \
	'test_must_fail $VCSH list-tracked-by'

test_expect_failure 'list-tracked-by fails if argument is not a repo' \
	'test_must_fail $VCSH list-tracked-by nope'

test_expect_success 'list-tracked-by lists files from specified repo' \
	'{
		echo "$HOME/a" &&
		echo "$HOME/d"
	} >expected &&
	$VCSH list-tracked-by foo >output &&
	test_cmp expected output &&

	{
		echo "$HOME/b" &&
		echo "$HOME/e"
	} >expected &&
	$VCSH list-tracked-by bar >output &&
	test_cmp expected output'

test_done
