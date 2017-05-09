#!/usr/bin/env bats

load environment

@test "Version command succeeds" {
	$VCSH version
}

@test "Version command prints vcsh and git versions" {
	run $VCSH version
	echo "${lines[0]}" | assert_grep '^vcsh [0-9]'
	echo "${lines[1]}" | assert_grep '^git version [0-9]'
}

@test "Version can be abbreviated (versio, versi, vers, ver, ve)" {
	run $VCSH version
	expected=$output

	for cmd in versio versi vers ver ve; do
		run $VCSH $cmd
		assert "$status" -eq 0
		assert "$output" = "$expected"
	done
}
