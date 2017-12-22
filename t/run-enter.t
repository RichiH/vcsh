#!/bin/bash

test_description='Run/enter commands'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_setup 'Create and populate repos' \
	'test_create_repo repo1 &&
	test_create_repo repo2 &&
	test_commit -C repo1 A &&
	test_commit -C repo2 B &&
	
	$VCSH clone ./repo1 foo &&
	$VCSH clone ./repo2 bar'

test_expect_success 'Run executes command inside specific repository' \
	'git -C repo1 rev-parse HEAD >expected &&
	$VCSH run foo git rev-parse HEAD >output &&
	test_cmp expected output &&

	git -C repo2 rev-parse HEAD >expected &&
	$VCSH run bar git rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Run implied if no explicit command specified' \
	'git -C repo1 rev-parse HEAD >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output &&

	git -C repo2 rev-parse HEAD >expected &&
	$VCSH bar rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Run can be abbreviated (ru)' \
	'git -C repo1 rev-parse HEAD >expected &&
	$VCSH ru foo git rev-parse HEAD >output &&
	test_cmp expected output'

test_expect_success 'Run returns exit status of subcommand' \
	'test_expect_code 104 $VCSH run foo sh -c "exit 104" &&
	test_expect_code 42 $VCSH run foo sh -c "exit 42" &&
	test_expect_code 93 $VCSH run foo sh -c "exit 93"'

test_expect_success 'Enter executes inside specific repository' \
	'git -C repo1 rev-parse HEAD >expected &&
	echo "git rev-parse HEAD" | test_env SHELL=/bin/sh $VCSH enter foo >output &&
	test_cmp expected output &&

	git -C repo2 rev-parse HEAD >expected &&
	echo "git rev-parse HEAD" | test_env SHELL=/bin/sh $VCSH enter bar >output &&
	test_cmp expected output'

test_expect_success 'Enter executes $SHELL inside repository' \
	'git -C repo1 rev-parse HEAD >expected &&
	SHELL="git rev-parse HEAD" $VCSH enter foo >output &&
	test_cmp expected output'

test_expect_success 'Enter implied for single non-command argument' \
	'git -C repo1 rev-parse HEAD >expected &&
	echo "git rev-parse HEAD" | test_env SHELL=/bin/sh $VCSH foo >output &&
	test_cmp expected output &&

	git -C repo2 rev-parse HEAD >expected &&
	echo "git rev-parse HEAD" | test_env SHELL=/bin/sh $VCSH bar >output &&
	test_cmp expected output'

# BUG: enter does not pass on subshell's exit status
test_expect_failure 'Enter returns exit status of subshell' \
	'echo "exit 104" | test_expect_code 104 test_env SHELL=/bin/sh $VCSH enter foo &&
	echo "exit 42" | test_expect_code 42 test_env SHELL=/bin/sh $VCSH enter foo &&
	echo "exit 93" | test_expect_code 93 test_env SHELL=/bin/sh $VCSH enter foo'

test_expect_success 'Enter can be abbreviated (ente, ent, en)' \
	'git -C repo1 rev-parse HEAD HEAD HEAD >expected &&

	{
		echo "git rev-parse HEAD" | SHELL=/bin/sh $VCSH ente foo &&
		echo "git rev-parse HEAD" | SHELL=/bin/sh $VCSH ent foo &&
		echo "git rev-parse HEAD" | SHELL=/bin/sh $VCSH en foo
	} >output &&

	test_cmp expected output'

test_done
