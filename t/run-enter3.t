#!/bin/bash

test_description='Run/enter commands'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Run returns exit status of subcommand' \
	'$VCSH init foo &&

	test_expect_code 104 $VCSH run foo sh -c "exit 104" &&
	test_expect_code 42 $VCSH run foo sh -c "exit 42" &&
	test_expect_code 93 $VCSH run foo sh -c "exit 93"'

test_done
