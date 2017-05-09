#!/bin/bash

test_description='List command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'List command displays multiple repositories' \
	'$VCSH init foo &&
	$VCSH init bar &&
	$VCSH init baz &&
	echo bar >expected &&
	echo baz >>expected &&
	echo foo >>expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
