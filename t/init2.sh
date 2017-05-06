#!/bin/bash

test_description='Init command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Init command creates new Git repository' \
	'output=$(num_gitrepos "$PWD") &&
	assert "$output" = "0" &&

	for i in $(seq 5)
	do
		$VCSH init "test$i" &&
		output=$(num_gitrepos "$PWD") &&
		assert "$output" = "$i"
	done'

test_done
