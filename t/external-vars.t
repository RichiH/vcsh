#!/bin/sh

test_description='External environment variables'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_setup 'Create a test repository' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	$VCSH init foo'

test_expect_failure 'No interference from $COLORING' \
	'test_env COLORING=--fail $VCSH status --terse >output 2>&1 &&
	test_must_be_empty output'

test_expect_failure 'No interference from $VCSH_COMMAND_RETURN_CODE' \
	'test_env VCSH_COMMAND_RETURN_CODE=1 $VCSH list'

test_expect_failure 'No interference from $VCSH_CONFLICT' \
	'test_env VCSH_CONFLICT=1 $VCSH clone repo bar &&
	doit | $VCSH delete bar'

test_expect_failure 'No interference from $VCSH_OPTION_CONFIG' \
	'test_env VCSH_OPTION_CONFIG=nothing $VCSH list'

test_expect_failure 'No interference from $VCSH_STATUS_TERSE' \
	'echo "foo:" >>expected &&
	echo ""     >>expected &&
	test_env VCSH_STATUS_TERSE=1 $VCSH status >output &&
	test_cmp expected output'

# XXX: `test_env ran_once=1 $VCSH list-untracked' is also problematic but
# may not be worth writing a test for

test_done
