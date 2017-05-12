#!/bin/bash

test_description='Rename command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Rename adopts existing .gitignore.d files under new name (bug?)' \
	'$VCSH init foo &&

	mkdir -p .gitignore.d &&
	echo test > .gitignore.d/bar &&

	$VCSH rename foo bar &&
	echo ".gitignore.d/bar" >expected &&
	$VCSH bar ls-files >output &&
	test_cmp expected output'

test_done
