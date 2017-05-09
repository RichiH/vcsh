#!/bin/bash

test_description='List command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'List command prioritizes \$VCSH_REPO_D over \$XDG_CONFIG_HOME' \
	'test_env XDG_CONFIG_HOME="$PWD/foo" $VCSH init correct &&
	test_env XDG_CONFIG_HOME="$PWD/bar" $VCSH init wrong &&

	echo correct >expected &&
	test_env XDG_CONFIG_HOME="$PWD/bar" VCSH_REPO_D="$PWD/foo/vcsh/repo.d" $VCSH list >output &&
	test_cmp expected output'

test_done
