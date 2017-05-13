#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'pull succeeds if up-to-date' \
	'git clone "$TESTREPO" upstream &&
	$VCSH clone upstream foo &&

	echo -e "foo: Already up-to-date.\\n" >expected &&
	$VCSH pull >output &&
	test_cmp expected output'

test_done
