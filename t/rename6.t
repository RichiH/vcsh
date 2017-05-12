#!/bin/bash

test_description='Rename command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Rename adopts existing .gitattributes.d files under new name (bug?)' \
	'$VCSH init foo &&

	mkdir -p .gitattributes.d &&
	echo "* whitespace" > .gitattributes.d/bar &&

	$VCSH rename foo bar &&
	echo ".gitattributes.d/bar" >expected &&
	$VCSH bar ls-files >output &&
	test_cmp expected output'

test_done
