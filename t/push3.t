#!/bin/bash

test_description='Push command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'push works with multiple repositories' \
	'test_create_repo repo1 &&
	test_create_repo repo2 &&
	test_commit -C repo1 A &&
	test_commit -C repo2 B &&
	git clone --bare ./repo1 repo1.git &&
	git clone --bare ./repo2 repo2.git &&

	$VCSH clone repo1.git foo &&
	$VCSH foo config push.default simple &&
	$VCSH clone repo2.git bar &&
	$VCSH bar config push.default simple &&

	$VCSH foo commit --allow-empty -m "empty" &&
	$VCSH bar commit --allow-empty -m "empty" &&
	$VCSH push &&

	$VCSH foo rev-parse HEAD >expected &&
	git -C repo1.git rev-parse HEAD >output &&
	test_cmp expected output &&

	$VCSH bar rev-parse HEAD >expected &&
	git -C repo2.git rev-parse HEAD >output &&
	test_cmp expected output'

test_done
