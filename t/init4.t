#!/bin/bash

test_description='Init command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

# XXX test instead by making sure files are actually excluded, not by
# reading config option
test_expect_success 'Init command sets core.excludesfile with VCSH_GITIGNORE=exact' \
	'test_env VCSH_GITIGNORE=exact $VCSH init test1 &&
	$VCSH run test1 git config core.excludesfile'

test_done
