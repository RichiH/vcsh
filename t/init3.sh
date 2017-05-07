#!/bin/bash

test_description='Init command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'VCSH_GITIGNORE variable is validated' \
	'test_env VCSH_GITIGNORE=x test_must_fail $VCSH init foo &&
	test_env VCSH_GITIGNORE=nonsense test_must_fail $VCSH init foo &&
	test_env VCSH_GITIGNORE=fhqwhgads test_must_fail $VCSH init foo'

test_done
