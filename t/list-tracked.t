#!/bin/sh

test_description='List-tracked command'

. ./sharness/sharness.sh
. "$SHARNESS_TEST_DIRECTORY/environment.sh"

test_expect_success 'list-tracked works with no repos' \
	'$VCSH list-tracked >output 2>&1 &&
	test_must_be_empty output'

test_setup 'Create some files' \
	'touch a b c d e'

test_expect_success 'list-tracked command works with no repos and untracked files' \
	'$VCSH list-tracked >output &&
	test_must_be_empty output'

test_expect_failure 'list-tracked fails if argument is not a repo' \
	'test_must_fail $VCSH list-tracked nope'

test_setup 'Create repo' \
	'$VCSH init foo'

test_expect_success 'list-tracked works on empty repo' \
	'$VCSH list-tracked >output &&
	test_must_be_empty output'

test_expect_success 'list-tracked works on specified empty repo' \
	'$VCSH list-tracked foo >output &&
	test_must_be_empty output'

test_setup 'Commit some files' \
	'$VCSH foo add a d &&
	$VCSH foo commit -m "a d"'

test_expect_success 'list-tracked lists files from one repo' \
	'{
		echo "$HOME/a" &&
		echo "$HOME/d"
	} >expected &&
	$VCSH list-tracked >output &&
	test_cmp expected output'

test_setup 'Set up second repo' \
	'$VCSH init bar &&

	$VCSH bar add b e &&
	$VCSH bar commit -m "b e"'

test_expect_success 'list-tracked lists files from two repos' \
	'{
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
