#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'pull works with one repository' \
	'git clone "$TESTREPO" upstream &&
	$VCSH clone upstream foo &&

	git -C upstream commit --allow-empty -m "empty" &&
	git -C upstream rev-parse HEAD >expected &&

	$VCSH pull &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output'

test_done
