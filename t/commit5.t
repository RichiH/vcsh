#!/bin/bash

test_description='Commit command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

# Known bug
test_expect_failure 'commit not affected by existing $VCSH_COMMAND_RETURN_CODE' \
	'VCSH_COMMAND_RETURN_CODE=1 &&
	export VCSH_COMMAND_RETURN_CODE &&
	$VCSH commit'

test_done
