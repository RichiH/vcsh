#!/bin/bash

test_description='Rename command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Rename can be abbreviated (renam, rena, ren, re)' \
	'$VCSH init foo &&

	$VCSH renam foo bar &&
	$VCSH rena bar baz &&
	$VCSH ren baz bat &&
	$VCSH re bat quux &&

	echo quux >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
