#!/bin/bash

test_description='Delete command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Delete lists staged files before confirmation' \
	'$VCSH init foo &&
	touch randomtexttofind &&
	$VCSH foo add randomtexttofind &&

	: | $VCSH delete foo | assert_grep -F randomtexttofind'

test_done
