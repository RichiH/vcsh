#!/bin/bash

test_description='Which command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Which command searches all repos' \
	'$VCSH init foo &&
	$VCSH init bar &&
	$VCSH init baz &&

	mkdir -p a b c &&
	touch {a,b,c}/{hello,goodbye} &&
	$VCSH foo add a &&
	$VCSH foo commit -m "hello" &&
	$VCSH bar add b &&
	$VCSH bar commit -m "hello" &&
	$VCSH baz add c &&
	$VCSH baz commit -m "hello" &&

	echo "bar: b/hello"  >expected &&
	echo "baz: c/hello" >>expected &&
	echo "foo: a/hello" >>expected &&
	$VCSH which hello >output &&
	test_cmp expected output'

test_done
