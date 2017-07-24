#!/bin/bash

test_description='Rename command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_setup 'Create repo and make commits' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	test_commit -C repo B'

test_expect_success 'Repository to be renamed must exist' \
	'test_must_fail $VCSH rename foo bar'

test_setup 'Create empty and nonempty repos' \
	'$VCSH init foo &&
	$VCSH init foo2 &&
	$VCSH clone ./repo bar'

test_expect_success 'Rename works on empty repository' \
	'$VCSH rename foo baz &&
	test_when_finished "$VCSH rename baz foo" &&

	echo bar  >expected &&
	echo baz >>expected &&
	echo foo2>>expected &&

	$VCSH list >output &&
	test_cmp expected output'

test_expect_success 'Rename works on repository with files/commits' \
	'$VCSH rename bar baz &&
	test_when_finished "$VCSH rename baz bar" &&

	git -C repo rev-parse HEAD >expected &&
	$VCSH baz rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Rename requires two arguments' \
	'test_must_fail $VCSH rename &&
	test_must_fail $VCSH rename bar'

test_expect_success 'Target of rename must not already exist' \
	'test_must_fail $VCSH rename foo bar'

test_expect_success 'Rename adopts existing .gitignore.d files under new name (bug?)' \
	'mkdir -p .gitignore.d &&
	test_when_finished "rm -r .gitignore.d/" &&
	echo test > .gitignore.d/baz &&

	$VCSH rename foo baz &&
	test_when_finished "$VCSH rename baz foo" &&

	echo ".gitignore.d/baz" >expected &&
	$VCSH baz ls-files >output &&
	test_cmp expected output'

test_expect_success 'Rename adopts existing .gitattributes.d files under new name (bug?)' \
	'mkdir -p .gitattributes.d &&
	test_when_finished "rm -r .gitattributes.d/" &&
	echo "* whitespace" > .gitattributes.d/baz &&

	$VCSH rename foo2 baz &&
	test_when_finished "$VCSH rename baz foo2" &&

	echo ".gitattributes.d/baz" >expected &&
	$VCSH baz ls-files >output &&
	test_cmp expected output'

test_expect_success 'Rename can be abbreviated (renam, rena, ren, re)' \
	'$VCSH init name1 &&

	$VCSH renam name1 name2 &&
	$VCSH rena name2 name3 &&
	$VCSH ren name3 name4 &&
	$VCSH re name4 name5 &&
	test_when_finished "doit | $VCSH delete name5" &&

	echo name5 >expected &&
	$VCSH list >output &&
	test_grep -Fx name5 <output &&
	test_must_fail test_grep -Fx name4 <output &&
	test_must_fail test_grep -Fx name3 <output &&
	test_must_fail test_grep -Fx name2 <output &&
	test_must_fail test_grep -Fx name1 <output'

test_done
