#!/bin/bash

test_description='Foreach command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Foreach supports -g for non-Git commands' \
	'$VCSH clone -b "$TESTBR1" "$TESTREPO" foo &&
	$VCSH clone -b "$TESTBR2" "$TESTREPO" bar &&

	{
		echo "bar:" &&
		echo "test-output" &&
		echo "foo:" &&
		echo "test-output"
	} >expected &&

	$VCSH foreach -g echo test-output >output &&
	test_cmp expected output'

test_done
