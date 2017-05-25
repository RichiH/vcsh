#!/bin/bash

test_description='Rename command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_success 'Setup' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	test_commit -C repo B'

test_expect_success 'Repository to be renamed must exist' \
	'test_must_fail $VCSH rename foo bar'

test_expect_success 'Rename works on empty repository' \
	'$VCSH init foo &&
	$VCSH rename foo bar &&

	echo bar >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_expect_success 'Rename works on repository with files/commits' \
	'git -C repo rev-parse HEAD >expected &&

	$VCSH clone ./repo foo &&
	$VCSH rename foo baz &&
	$VCSH baz rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Rename requires two arguments' \
	'test_must_fail $VCSH rename &&
	test_must_fail $VCSH rename bar'

test_expect_success 'Target of rename must not already exist' \
	'test_must_fail $VCSH rename bar baz'

test_expect_success 'Rename adopts existing .gitignore.d files under new name (bug?)' \
	'mkdir -p .gitignore.d &&
	echo test > .gitignore.d/foo &&

	$VCSH rename bar foo &&
	echo ".gitignore.d/foo" >expected &&
	$VCSH foo ls-files >output &&
	test_cmp expected output'

test_expect_success 'Rename adopts existing .gitattributes.d files under new name (bug?)' \
	'$VCSH init bar &&

	mkdir -p .gitattributes.d &&
	echo "* whitespace" > .gitattributes.d/fribble &&

	$VCSH rename bar fribble &&
	echo ".gitattributes.d/fribble" >expected &&
	$VCSH fribble ls-files >output &&
	test_cmp expected output'

test_expect_success 'Rename can be abbreviated (renam, rena, ren, re)' \
	'$VCSH init name1 &&

	$VCSH renam name1 name2 &&
	$VCSH rena name2 name3 &&
	$VCSH ren name3 name4 &&
	$VCSH re name4 name5 &&

	echo name5 >expected &&
	$VCSH list >output &&
	test_grep -Fx name5 <output &&
	test_must_fail test_grep -Fx name4 <output &&
	test_must_fail test_grep -Fx name3 <output &&
	test_must_fail test_grep -Fx name2 <output &&
	test_must_fail test_grep -Fx name1 <output'

test_done
