#!/bin/bash

test_description='Push command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'push fails if last push fails' \
	'git clone --bare -b "$TESTBR1" "$TESTREPO" upstream1.git &&
	git clone --bare -b "$TESTBR2" "$TESTREPO" upstream2.git &&

	$VCSH clone -b "$TESTBR1" upstream1.git a &&
	$VCSH a config push.default simple &&
	$VCSH clone -b "$TESTBR2" upstream2.git b &&
	$VCSH b config push.default simple &&

	$VCSH a commit --allow-empty -m 'empty' &&
	$VCSH b commit --allow-empty -m 'empty' &&

	rm -rf upstream2.git &&
	test_must_fail $VCSH push'

test_done
