#!/usr/bin/env bats

load environment

@test "Status command correct for no repos" {
	run $VCSH status
	[ "$status" -eq 0 ]
	[ "$output" = '' ]
}

@test "Status command correct for empty repo" {
	$VCSH init foo

	run $VCSH status
	[ "$status" -eq 0 ]
	[ "$output" = 'foo:' ]
}

@test "Status command correct for multiple empty repos" {
	$VCSH init foo
	$VCSH init bar

	run $VCSH status
	[ "$status" -eq 0 ]
	[ "$output" = $'bar:\n\nfoo:' ]
}

@test "Terse status correct for empty repo" {
	$VCSH init foo

	run $VCSH status --terse
	[ "$status" -eq 0 ]
	[ "$output" = '' ]
}

@test "Terse status correct for multiple empty repos" {
	$VCSH init foo
	$VCSH init bar

	run $VCSH status --terse
	[ "$status" -eq 0 ]
	[ "$output" = '' ]
}

@test "Status colored when output to tty" {
	which socat || skip "socat required to create pseudo-tty"

	$VCSH init foo
	touch a
	$VCSH run foo git add a
	$VCSH run foo git config --local color.status.added green

	run socat -u exec:"$VCSH status foo",pty,rawer stdio
	[ "$output" = $'\e[32mA\e[m  a' ]
}
