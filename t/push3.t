#!/bin/bash

test_description='Push command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'push works with multiple repositories' \
	'git clone --bare -b "$TESTBR1" "$TESTREPO" upstream1.git &&
	git clone --bare -b "$TESTBR2" "$TESTREPO" upstream2.git &&

	$VCSH clone -b "$TESTBR1" upstream1.git foo &&
	$VCSH foo config push.default simple &&
	$VCSH clone -b "$TESTBR2" upstream2.git bar &&
	$VCSH bar config push.default simple &&

	$VCSH foo commit --allow-empty -m 'empty' &&
	$VCSH bar commit --allow-empty -m 'empty' &&
	$VCSH push &&

	$VCSH foo rev-parse HEAD >expected &&
	git -C upstream1.git rev-parse HEAD >output &&
	test_cmp expected output &&

	$VCSH bar rev-parse HEAD >expected &&
	git -C upstream2.git rev-parse HEAD >output &&
	test_cmp expected output'

test_done
