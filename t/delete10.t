#!/bin/bash

test_description='Delete command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_failure 'Delete handles filenames with spaces properly' \
	'$VCSH init foo &&
	touch a b "a b" &&
	$VCSH foo add "a b" &&
	$VCSH foo commit -m "a b" &&

	doit | $VCSH delete foo &&
	test_path_is_missing "a b" &&
	test_path_is_file a &&
	test_path_is_file b'

test_done
