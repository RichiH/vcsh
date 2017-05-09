#!/bin/bash

test_description='Delete command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

# Do we actually want this?
test_expect_failure 'Delete lists files staged for removal before confirmation' \
	'$VCSH init foo &&
	touch randomtexttofind &&
	$VCSH foo add randomtexttofind &&
	$VCSH foo commit -m 'a' &&
	$VCSH foo rm --cached randomtexttofind &&

	: | $VCSH delete foo | assert_grep -F randomtexttofind'

test_done
