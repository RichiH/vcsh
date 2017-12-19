#!/bin/bash

test_description='List-untracked command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_setup 'Avoid creating additional untracked dirs/files' \
	'export VCSH_GITIGNORE=none VCSH_GITATTRIBUTES=none'

test_expect_success 'list-untracked works with no repos' \
	'$VCSH list-untracked &>output &&
	test_must_be_empty output'

# Bug
test_expect_failure 'list-untracked argument must be a repo' \
	'test_must_fail $VCSH list-untracked nope'

test_setup 'Create directory to isolate files' \
	'mkdir files &&
	export VCSH_BASE="$PWD/files"'

test_expect_success 'list-untracked works with no files' \
	'$VCSH list-untracked >output &&
	test_must_be_empty output'

test_setup 'Create some files/directories' \
	'mkdir files/{tracked,part,untracked} &&
	touch files/{a,b,tracked/{c,d},part/{e,f},untracked/{g,h}}'

# Bug?
test_expect_failure 'list-untracked works with no repos' \
	'{
		echo a &&
		echo b &&
		echo part/ &&
		echo tracked/ &&
		echo untracked/
	} >expected &&
	$VCSH list-untracked >output &&
	test_cmp expected output'

# Bug?
test_expect_failure 'list-untracked -r works with no repos' \
	'{
		echo a &&
		echo b &&
		echo part/e &&
		echo part/f &&
		echo tracked/c &&
		echo tracked/d &&
		echo untracked/g &&
		echo untracked/h
	} >expected &&
	$VCSH list-untracked -r >output &&
	test_cmp expected output'

test_setup 'Initialize empty repository' \
	'$VCSH init foo'

test_expect_success 'list-untracked works with one empty repo' \
	'{
		echo a &&
		echo b &&
		echo part/ &&
		echo tracked/ &&
		echo untracked/
	} >expected &&
	$VCSH list-untracked >output &&
	test_cmp expected output'

test_expect_success 'list-untracked -r works with one empty repo' \
	'{
		echo a &&
		echo b &&
		echo part/e &&
		echo part/f &&
		echo tracked/c &&
		echo tracked/d &&
		echo untracked/g &&
		echo untracked/h
	} >expected &&
	$VCSH list-untracked -r >output &&
	test_cmp expected output'

test_setup 'Add some files to repository' \
	'$VCSH foo add a tracked/d &&
	$VCSH foo commit -m "files"'

test_expect_success 'list-untracked does not include tracked files for one repo' \
	'{
		echo a &&
		echo tracked/d
	} >bad &&
	$VCSH list-untracked >output &&
	test_must_fail test_grep -Fx -f bad <output'

test_expect_success 'list-untracked shows completely untracked directory' \
	'$VCSH list-untracked >output &&
	test_grep -Fx untracked/ <output'

test_expect_success 'list-untracked -r shows contents of completely untracked directory' \
	'$VCSH list-untracked -r >output &&
	test_grep -Fx untracked/g <output &&
	test_grep -Fx untracked/h <output'

# list-untracked -r shows contents of completely untracked directory
# list-untracked shows contents of partially untracked directory
# list-untracked -r shows contents of partially untracked directory
# list-untracked does not show tracked directory
# list-untracked -r does not show tracked directory

# Bug
test_expect_failure 'list-untracked not affected by $ran_once in environment' \
	'test_env ran_once=1 $VCSH list-untracked >output &&
	test_cmp expected output'

# XXX Needs tests for multiple repos, with and without -r

test_done
