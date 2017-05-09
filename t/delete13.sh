#!/bin/bash

test_description='Delete command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Delete can be abbreviated (delet, dele, del, de)' \
	'$VCSH init a &&
	$VCSH init b &&
	$VCSH init c &&
	$VCSH init d &&

	doit | $VCSH delet a &&
	! $VCSH list | assert_grep -Fx a &&

	doit | $VCSH dele b &&
	! $VCSH list | assert_grep -Fx b &&

	doit | $VCSH del c &&
	! $VCSH list | assert_grep -Fx c &&

	doit | $VCSH de d &&
	! $VCSH list | assert_grep -Fx d'

test_done
