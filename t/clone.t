#!/bin/bash

test_description='Clone command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_setup 'Create upstream repos' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	git -C repo checkout -b branchb &&
	test_commit -C repo A2 &&
	git -C repo checkout master &&

	test_create_repo repo2 &&
	test_commit -C repo2 B &&

	git clone --bare repo2 repo3.git'

test_expect_success 'Clone requires a remote' \
	'test_must_fail $VCSH clone'

test_expect_success 'Clone uses existing repo name by default' \
	'$VCSH clone ./repo &&
	test_when_finished "doit | $VCSH delete repo" &&
	echo "repo" >expected &&
	$VCSH list >output &&

	$VCSH clone ./repo3.git &&
	test_when_finished "doit | $VCSH delete repo3" &&
	echo "repo3" >>expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_expect_success 'Clone honors specified repo name' \
	'$VCSH clone ./repo foo &&
	test_when_finished "doit | $VCSH delete foo" &&
	echo foo >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_expect_success 'Clone defaults to HEAD of given remote' \
	'$VCSH clone ./repo foo &&
	test_when_finished "doit | $VCSH delete foo" &&
	git -C repo rev-parse HEAD >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Clone can be abbreviated "clon"' \
	'$VCSH clon ./repo a &&
	test_when_finished "doit | $VCSH delete a" &&
	echo a >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_expect_success 'Clone can be abbreviated "clo"' \
	'$VCSH clo ./repo b &&
	test_when_finished "doit | $VCSH delete b" &&
	echo b >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_expect_success 'Clone can be abbreviated "cl"' \
	'$VCSH cl ./repo c &&
	test_when_finished "doit | $VCSH delete c" &&
	echo c >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_expect_success 'Clone honors -b option before remote' \
	'$VCSH clone -b branchb ./repo &&
	test_when_finished "doit | $VCSH delete repo" &&
	git -C repo rev-parse branchb >expected &&
	$VCSH repo rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Clone honors -b option before remote and repo name' \
	'$VCSH clone -b branchb ./repo foo &&
	test_when_finished "doit | $VCSH delete foo" &&
	git -C repo rev-parse branchb >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Clone honors -b option after remote' \
	'$VCSH clone ./repo -b branchb &&
	test_when_finished "doit | $VCSH delete repo" &&
	git -C repo rev-parse branchb >expected &&
	$VCSH repo rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Clone honors -b option between remote and repo name' \
	'$VCSH clone ./repo -b branchb foo &&
	test_when_finished "doit | $VCSH delete foo" &&
	git -C repo rev-parse branchb >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Clone honors -b option after repo name' \
	'$VCSH clone ./repo foo -b branchb &&
	test_when_finished "doit | $VCSH delete foo" &&
	git -C repo rev-parse branchb >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Clone -b option clones only one branch' \
	'$VCSH clone -b branchb ./repo foo &&
	test_when_finished "doit | $VCSH delete foo" &&
	$VCSH foo show-ref --heads >output &&
	test_line_count = 1 output'

test_done
