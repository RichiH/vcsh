#!/bin/bash

test_description='Clone command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone uses existing repo name by default' \
	'test_create_repo repo1 &&
	test_create_repo repo2 &&
	test_commit -C repo1 A &&
	test_commit -C repo2 B &&
	git clone --bare repo2 repo3.git &&

	$VCSH clone ./repo &&
	echo "repo" >expected &&
	$VCSH list >output &&

	$VCSH clone ./repo3.git &&
	echo "repo3" >>expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
