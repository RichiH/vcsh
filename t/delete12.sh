#!/bin/bash

test_description='Delete command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_failure 'Delete handles filenames with wildcard characters properly' \
	'$VCSH init foo &&
	touch a b "?" &&
	$VCSH foo add '\''\?'\'' &&
	$VCSH foo commit -m "?" &&

	doit | $VCSH delete foo &&
	test_path_is_missing "?" &&
	test_path_is_file a &&
	test_path_is_file b'

test_done
