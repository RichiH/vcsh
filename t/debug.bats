#!/usr/bin/env bats

load environment

@test "Debug output includes git version" {
	$VCSH -d init foo |& assert_grep 'git version [0-9]'
	$VCSH -d list |& assert_grep 'git version [0-9]'
	# XXX add more?
}
