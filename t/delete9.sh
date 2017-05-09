#!/bin/bash

test_description='Delete command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Delete removes corresponding files' \
	'$VCSH init foo &&
	$VCSH init bar &&

	touch a b c d e &&
	$VCSH foo add b e &&
	$VCSH foo commit -m "b e" &&
	$VCSH bar add a c &&
	$VCSH bar commit -m "a c" &&

	doit | $VCSH delete foo &&
	test_path_is_missing b &&
	test_path_is_missing e &&
	test_path_is_file a &&
	test_path_is_file c &&
	test_path_is_file d &&

	doit | $VCSH delete bar &&
	test_path_is_missing a &&
	test_path_is_missing c &&
	test_path_is_file d'

test_done
