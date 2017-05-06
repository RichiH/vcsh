#!/bin/bash

test_description='Init command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Init command sets core.attributesfile with VCSH_GITATTRIBUTES!=none' \
	'VCSH_GITATTRIBUTES=whatever $VCSH init test1 &&
	$VCSH run test1 git config core.attributesfile'

test_done
