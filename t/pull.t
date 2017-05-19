#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'pull works with no repositories' \
	'$VCSH pull >output &&
	test_must_be_empty output'

test_expect_success 'pull succeeds if up-to-date' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	$VCSH clone ./repo foo &&

	echo -e "foo: Already up-to-date.\\n" >expected &&
	$VCSH pull >output &&
	test_cmp expected output'

test_expect_success 'pull works with one repository' \
	'test_commit -C repo B &&
	git -C repo rev-parse HEAD >expected &&

	$VCSH pull &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'pull works with multiple repositories' \
	'test_create_repo repo2 &&
	test_commit -C repo2 C &&
	$VCSH clone ./repo2 bar &&

	test_commit -C repo X &&
	git -C repo rev-parse HEAD >expected &&

	$VCSH pull &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output &&

	test_commit -C repo2 Y &&
	git -C repo2 rev-parse HEAD >expected &&

	$VCSH pull &&
	$VCSH bar rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_failure 'pull fails if first pull fails' \
	'mv repo2 repo2.missing &&
	test_when_finished "mv repo2.missing repo2" &&

	test_commit -C repo D &&

	test_must_fail $VCSH pull'

test_expect_success 'pull fails if last pull fails' \
	'mv repo repo.missing &&
	test_when_finished "mv repo.missing repo" &&

	test_commit -C repo2 E &&

	test_must_fail $VCSH pull'

test_done
