#!/bin/bash

test_description='Push command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'push fails if last push fails' \
	'test_create_repo repo1 &&
	test_create_repo repo2 &&
	test_commit -C repo1 A &&
	test_commit -C repo2 B &&
	git clone --bare ./repo1 repo1.git &&
	git clone --bare ./repo2 repo2.git &&

	$VCSH clone repo1.git a &&
	$VCSH a config push.default simple &&
	$VCSH clone repo2.git b &&
	$VCSH b config push.default simple &&

	$VCSH a commit --allow-empty -m "empty" &&
	$VCSH b commit --allow-empty -m "empty" &&

	rm -rf repo2.git &&
	test_must_fail $VCSH push'

test_done
