#!/bin/bash

test_description='Clone command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Setup' \
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
	echo "repo" >expected &&
	$VCSH list >output &&

	$VCSH clone ./repo3.git &&
	echo "repo3" >>expected &&
	$VCSH list >output &&
	test_cmp expected output &&
	
	doit | $VCSH delete repo &&
	doit | $VCSH delete repo3'

test_expect_success 'Clone honors specified repo name' \
	'$VCSH clone ./repo foo &&
	echo foo >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_expect_success 'Clone defaults to HEAD of given remote' \
	'git -C repo rev-parse HEAD >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output &&
	
	doit | $VCSH delete foo'

test_expect_success 'Clone can be abbreviated (clon, clo, cl)' \
	'$VCSH clon ./repo a &&
	echo a >expected &&
	$VCSH list >output &&
	test_cmp expected output &&
	doit | $VCSH delete a &&

	$VCSH clo ./repo b &&
	echo b >expected &&
	$VCSH list >output &&
	test_cmp expected output &&
	doit | $VCSH delete b &&

	$VCSH cl ./repo c &&
	echo c >expected &&
	$VCSH list >output &&
	test_cmp expected output &&
	doit | $VCSH delete c'

test_expect_success 'Clone honors -b option before remote' \
	'$VCSH clone -b branchb ./repo &&
	git -C repo rev-parse branchb >expected &&
	$VCSH repo rev-parse HEAD >output &&
	test_cmp expected output &&
	
	doit | $VCSH delete repo'

test_expect_success 'Clone honors -b option before remote and repo name' \
	'$VCSH clone -b branchb ./repo foo &&
	git -C repo rev-parse branchb >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output &&
	
	doit | $VCSH delete foo'

test_expect_success 'Clone honors -b option after remote' \
	'$VCSH clone ./repo -b branchb &&
	git -C repo rev-parse branchb >expected &&
	$VCSH repo rev-parse HEAD >output &&
	test_cmp expected output &&
	
	doit | $VCSH delete repo'

test_expect_success 'Clone honors -b option between remote and repo name' \
	'$VCSH clone ./repo -b branchb foo &&
	git -C repo rev-parse branchb >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output &&
	
	doit | $VCSH delete foo'

test_expect_success 'Clone honors -b option after repo name' \
	'$VCSH clone ./repo foo -b branchb &&
	git -C repo rev-parse branchb >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output &&
	
	doit | $VCSH delete foo'

test_expect_success 'Clone -b option clones only one branch' \
	'$VCSH clone -b branchb ./repo foo &&
	$VCSH foo show-ref --heads >output &&
	test_line_count = 1 output &&
	
	doit | $VCSH delete foo'

test_done
