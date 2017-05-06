#!/bin/bash

test_description='Init command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Init command creates new Git repository' \
	'find_gitrepos "$PWD" >output &&
	test_must_be_empty output &&

	for i in $(test_seq 5); do
		$VCSH init "test$i" &&
		find_gitrepos "$PWD" >output &&
		test_line_count = "$i" output
	done'

test_done
