#!/bin/bash

test_description='Push command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'push works with one repository' \
	'git clone --bare "$TESTREPO" upstream.git &&

	$VCSH clone upstream.git foo &&
	$VCSH foo config push.default simple &&
	$VCSH foo commit --allow-empty -m 'empty' &&
	$VCSH foo rev-parse HEAD >expected &&

	$VCSH push &&
	git -C upstream.git rev-parse HEAD >output &&
	test_cmp expected output'

test_done
