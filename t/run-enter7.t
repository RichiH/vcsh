#!/bin/bash

test_description='Run/enter commands'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

# BUG: enter does not pass on subshell's exit status
test_expect_failure 'Enter returns exit status of subshell' \
	'$VCSH init foo &&

	echo "exit 104" | test_expect_code 104 test_env SHELL=/bin/sh $VCSH enter foo &&
	echo "exit 42" | test_expect_code 42 test_env SHELL=/bin/sh $VCSH enter foo &&
	echo "exit 93" | test_expect_code 93 test_env SHELL=/bin/sh $VCSH enter foo'

test_done
