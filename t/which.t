#!/bin/bash

test_description='Which command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_success 'Which command does not accept an empty parameter' \
	'test_must_fail $VCSH which ""'

test_expect_success 'Which command fails if no repositories' \
	'test_must_fail $VCSH which nope'

test_setup 'Create repository "foo"' \
	'$VCSH init foo &&

	mkdir -p dir/subd &&
	touch testfile dir/subfile dir/subd/bar calor color colour "colou?r" &&
	$VCSH foo add * &&
	$VCSH foo commit -m "commit"'

test_expect_success 'Which command fails if pattern not found' \
	'test_must_fail $VCSH which nope'

test_expect_success 'Which command requires exactly one parameter' \
	'test_must_fail $VCSH which &&
	test_must_fail $VCSH which foo bar'

test_expect_success 'Which command matches exact filename' \
	'echo "foo: testfile" >expected &&
	$VCSH which testfile >output &&
	test_cmp expected output'

test_expect_success 'Which command matches entire path' \
	'echo "foo: dir/subfile" >expected &&
	$VCSH which dir/subfile >output &&
	test_cmp expected output'

test_expect_success 'Which command matches filename within subdirectory' \
	'echo "foo: dir/subfile" >expected &&
	$VCSH which subfile >output &&
	test_cmp expected output'

test_expect_success 'Which command matches directory path component' \
	'echo "foo: dir/subd/bar" >expected &&
	$VCSH which subd >output &&
	test_cmp expected output'

test_expect_success 'Which command matches partial filename' \
	'echo "foo: dir/subfile" >expected &&
	$VCSH which ubfi >output &&
	test_cmp expected output'

test_expect_success 'Which command matches partial path component across slash (bug?)' \
	'echo "foo: dir/subd/bar" >expected &&
	$VCSH which bd/ba >output &&
	test_cmp expected output'

test_expect_success 'Which command matches using POSIX BRE' \
	'echo "foo: calor"  >expected &&
	echo "foo: color"  >>expected &&
	echo "foo: colour" >>expected &&
	$VCSH which "c.lou\\?r" >output &&
	test_cmp expected output'

test_setup 'Create and populate bar/baz repos' \
	'$VCSH init bar &&
	$VCSH init baz &&

	mkdir -p a b c &&
	touch a/hello b/hello c/hello a/goodbye b/goodbye c/goodbye &&
	$VCSH foo add a &&
	$VCSH foo commit -m "hello" &&
	$VCSH bar add b &&
	$VCSH bar commit -m "hello" &&
	$VCSH baz add c &&
	$VCSH baz commit -m "hello"'

test_expect_success 'Which command searches all repos' \
	'echo "bar: b/hello"  >expected &&
	echo "baz: c/hello" >>expected &&
	echo "foo: a/hello" >>expected &&
	$VCSH which hello >output &&
	test_cmp expected output'

test_done
