#!/bin/bash

test_description='Status command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Terse status correct for empty repo' \
	'$VCSH init foo &&

	$VCSH status --terse >output &&
	test_must_be_empty output'

test_done
