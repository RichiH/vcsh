#!/bin/bash

test_description='Init command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Init command does not set core.excludesfile with VCSH_GITIGNORE=none' \
	'test_env VCSH_GITIGNORE=none $VCSH init test1 &&
	test_must_fail $VCSH run test1 git config core.excludesfile'

test_done
