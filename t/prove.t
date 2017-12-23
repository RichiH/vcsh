#!/bin/sh

test_description='Old tests'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_success '300-add.t' \
	'$VCSH init test1 &&
	$VCSH init test2 &&

	touch a &&
	$VCSH test2 add a &&

	echo "test1:"  >expected &&
	echo ""       >>expected &&
	echo "test2:" >>expected &&
	echo "A  a"   >>expected &&
	echo ""       >>expected &&
	$VCSH status >output &&
	test_cmp expected output &&

	echo "test2:"  >expected &&
	echo "A  a"   >>expected &&
	$VCSH status --terse >output &&
	test_cmp expected output'

test_done
