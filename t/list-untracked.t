#!/bin/bash

test_description='List-untracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

# Needed to avoid creating additional untracked dirs/files
export VCSH_GITIGNORE=none VCSH_GITATTRIBUTES=none

test_expect_success 'list-untracked works with no repos' \
	'$VCSH list-untracked &>output &&
	test_must_be_empty output'

# Bug
test_expect_failure 'list-untracked argument must be a repo' \
	'test_must_fail $VCSH list-untracked nope'

test_expect_success '(setup) Create directory to isolate files' \
	'mkdir files &&
	export VCSH_BASE="$PWD/files"'

test_expect_success 'list-untracked works with no files' \
	'$VCSH list-untracked >output &&
	test_must_be_empty output'

# Bug?
test_expect_failure 'list-untracked works with no repos' \
	'mkdir files/dir &&
	touch files/a files/b files/c files/dir/d files/dir/e &&
	{
		echo a &&
		echo b &&
		echo c &&
		echo dir/
	} >expected &&
	$VCSH list-untracked >output &&
	test_cmp expected output'

# Bug?
test_expect_failure 'list-untracked -r works with no repos' \
	'{
		echo a &&
		echo b &&
		echo c &&
		echo dir/d &&
		echo dir/e
	} >expected &&
	$VCSH list-untracked -r >output &&
	test_cmp expected output'

test_expect_success 'list-untracked works with one empty repo' \
	'$VCSH init foo &&

	{
		echo a &&
		echo b &&
		echo c &&
		echo dir/
	} >expected &&
	$VCSH list-untracked >output &&
	test_cmp expected output'

test_expect_success 'list-untracked -r works with one empty repo' \
	'{
		echo a &&
		echo b &&
		echo c &&
		echo dir/d &&
		echo dir/e
	} >expected &&
	$VCSH list-untracked -r >output &&
	test_cmp expected output'

test_expect_success 'list-untracked works with one repo' \
	'$VCSH foo add a c dir/d &&
	$VCSH foo commit -m "files" &&

	{
		echo b &&
		echo dir/e
	} >expected &&
	$VCSH list-untracked >output &&
	test_cmp expected output'

# Bug
test_expect_failure 'list-untracked not affected by $ran_once in environment' \
	'test_env ran_once=1 $VCSH list-untracked >output &&
	test_cmp expected output'

# XXX Needs tests for multiple repos, with and without -r

test_done
