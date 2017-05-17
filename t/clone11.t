#!/bin/bash

test_description='Clone command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone can be abbreviated (clon, clo, cl)' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	git -C repo checkout --orphan branchb &&
	git -C repo rm -rf . &&
	test_commit -C repo B &&
	git -C repo checkout --orphan branchc &&
	git -C repo rm -rf . &&
	test_commit -C repo C &&
	git -C repo checkout master &&

	$VCSH clon ./repo a &&
	$VCSH clo -b branchb ./repo b &&
	$VCSH cl -b branchc ./repo c &&

	echo a > expected &&
	echo b >> expected &&
	echo c >> expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
