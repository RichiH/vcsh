#!/usr/bin/env bats

load environment

@test "Version command succeeds" {
	$VCSH version
}

@test "Version command prints vcsh and git versions" {
	run $VCSH version
	[[ "${lines[0]}" = 'vcsh '[0-9]* ]]
	[[ "${lines[1]}" = 'git version '[0-9]* ]]
}

@test "Version can be abbreviated (versio, versi, vers, ver, ve)" {
	run $VCSH version
	expected=$output

	for cmd in versio versi vers ver ve; do
		run $VCSH $cmd
		[ "$status" -eq 0 ]
		[ "$output" = "$expected" ]
	done
}
