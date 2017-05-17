#!/bin/bash

test_description='Push command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'push succeeds if up-to-date' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	git clone --bare ./repo repo.git &&

	$VCSH clone ./repo.git foo &&
	$VCSH foo config push.default simple &&

	echo -e "foo: Everything up-to-date\\n" >expected &&
	$VCSH push &>output &&
	test_cmp expected output'

test_done
