#!/usr/bin/env bats

load environment

@test "Status argument if any must be a repo" {
	! $VCSH status nope
}

@test "Status command correct for no repos" {
	run $VCSH status
	assert "$status" -eq 0
	assert "$output" = ''
}

@test "Status command correct for empty repo" {
	$VCSH init foo

	run $VCSH status
	assert "$status" -eq 0
	assert "$output" = 'foo:'
}

@test "Status command correct for multiple empty repos" {
	$VCSH init foo
	$VCSH init bar

	run $VCSH status
	assert "$status" -eq 0
	assert "$output" = $'bar:\n\nfoo:'
}

@test "Terse status correct for empty repo" {
	$VCSH init foo

	run $VCSH status --terse
	assert "$status" -eq 0
	assert "$output" = ''
}

@test "Terse status correct for multiple empty repos" {
	$VCSH init foo
	$VCSH init bar

	run $VCSH status --terse
	assert "$status" -eq 0
	assert "$output" = ''
}

@test "Status shows added/modified/moved/deleted files" {
	$VCSH init foo

	for f in 00 0M 0D M0 MM MD A0 AM AD D0 R0x RMx RDx oo; do
		echo "$f" > "$f"
	done
	$VCSH foo add 00 0M 0D M0 MM MD D0 R0x RMx RDx
	$VCSH foo commit -m 'commit'

	# Modified in index
	for f in M?; do
		echo changed > $f
	done
	$VCSH foo add M?

	# Added to index
	$VCSH foo add A?

	# Deleted in index
	$VCSH foo rm -q --cached D?

	# Renamed in index
	for f in R?x; do
		$VCSH foo mv "$f" "${f%x}"
	done

	# Modified locally
	for f in ?M; do
		echo localchanged > $f
	done

	# Deleted locally
	rm ?D

	run $VCSH status
	assert "$status" -eq 0
	assert "$output" = "$(printf '%s\n' \
		'foo:'         \
		' D 0D'        \
		' M 0M'        \
		'A  A0'        \
		'AD AD'        \
		'AM AM'        \
		'D  D0'        \
		'M  M0'        \
		'MD MD'        \
		'MM MM'        \
		'R  R0x -> R0' \
		'RD RDx -> RD' \
		'RM RMx -> RM')"
}

@test "Status shows commits behind upstream" {
	skip "Test not yet implemented"
}

@test "Status shows commits ahead of upstream" {
	skip "Test not yet implemented"
}

@test "Status shows commits behind and ahead of upstream" {
	skip "Test not yet implemented"
}

@test "Status colored when output to tty" {
	which socat || skip "socat required to create pseudo-tty"

	$VCSH init foo
	touch a
	$VCSH run foo git add a
	$VCSH run foo git config --local color.status.added green

	# Ensure terminal is something Git will attempt to color
	TERM=vt100
	export TERM
	run socat -u exec:"$VCSH status foo",pty,rawer stdio
	assert "$output" = $'\e[32mA\e[m  a'
}

@test "Status can be abbreviated (statu, stat, sta, st)" {
	$VCSH init foo
	touch a
	$VCSH foo add a

	run $VCSH status
	expected=$output

	for cmd in statu stat sta st; do
		run $VCSH $cmd
		assert "$status" -eq 0
		assert "$output" = "$expected"
	done
}
