#!/bin/bash

test_description='Which command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Which command matches using POSIX BRE' \
	'$VCSH init foo &&

	touch calor color colour 'colou?r' &&
	$VCSH foo add * &&
	$VCSH foo commit -m 'color' &&

	echo "foo: calor"   >expected &&
	echo "foo: color"  >>expected &&
	echo "foo: colour" >>expected &&
	$VCSH which "c.lou\\?r" >output &&
	test_cmp expected output'

test_done
