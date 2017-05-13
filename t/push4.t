#!/bin/bash

test_description='Push command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_failure 'push fails if first push fails' \
	'git clone --bare -b "$TESTBR1" "$TESTREPO" upstream1.git &&
	git clone --bare -b "$TESTBR2" "$TESTREPO" upstream2.git &&

	$VCSH clone -b "$TESTBR1" upstream1.git a &&
	$VCSH foo config push.default simple &&
	$VCSH clone -b "$TESTBR2" upstream2.git b &&
	$VCSH bar config push.default simple &&

	rm -rf upstream1.git &&
	$VCSH b commit --allow-empty -m 'empty' &&

	test_must_fail $VCSH push'

test_done
