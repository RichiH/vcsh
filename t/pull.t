#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_success 'pull works with no repositories' \
	'$VCSH pull >output &&
	test_must_be_empty output'

test_setup 'Create upstream and downstream repos' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	$VCSH clone ./repo foo'

test_expect_success 'pull succeeds if up-to-date' \
	'$VCSH pull'

test_setup 'Add upstream commit' \
	'test_commit -C repo B'

test_expect_success 'pull works with one repository' \
	'git -C repo rev-parse HEAD >expected &&

	$VCSH pull &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output'

test_setup 'Create second upstream/downstream repo' \
	'test_create_repo repo2 &&
	test_commit -C repo2 C &&
	$VCSH clone ./repo2 bar &&

	test_commit -C repo X &&
	test_commit -C repo2 Y'

test_expect_success 'pull works with multiple repositories' \
	'$VCSH pull &&

	git -C repo rev-parse HEAD >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output &&

	git -C repo2 rev-parse HEAD >expected &&
	$VCSH bar rev-parse HEAD >output &&
	test_cmp expected output'

test_setup 'Add more commits' \
	'test_commit -C repo D &&
	test_commit -C repo2 E'

test_expect_failure 'pull fails if first pull fails' \
	'mv repo2 repo2.missing &&
	test_when_finished "mv repo2.missing repo2" &&

	test_must_fail $VCSH pull'

test_expect_success 'pull fails if last pull fails' \
	'mv repo repo.missing &&
	test_when_finished "mv repo.missing repo" &&

	test_must_fail $VCSH pull'

test_done
