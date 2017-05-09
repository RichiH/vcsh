#!/usr/bin/env bats

load environment

@test "list-tracked works with no repos" {
	run $VCSH list-tracked
	assert "$status" -eq 0
	assert "$output" = ""
}

@test "list-tracked command works with no repos and untracked files" {
	touch a b c d e

	run $VCSH list-tracked
	assert "$status" -eq 0
	assert "$output" = ""
}

@test "list-tracked fails if argument is not a repo" {
	skip "BUG"

	! $VCSH list-tracked nope || false
}

@test "list-tracked works on empty repo" {
	touch a b c d e

	$VCSH init foo
	run $VCSH list-tracked
	assert "$status" -eq 0
	assert "$output" = ""
}

@test "list-tracked lists files from one repo" {
	$VCSH init foo

	touch a b c d e
	$VCSH foo add a d
	$VCSH foo commit -m 'a d'

	run $VCSH list-tracked
	assert "$status" -eq 0
	assert "$output" = "$(printf '%s\n' "$HOME/a" "$HOME/d")"
}

@test "list-tracked lists files from two repos" {
	$VCSH init foo
	$VCSH init bar

	touch a b c d e
	$VCSH foo add a b
	$VCSH foo commit -m 'a b'
	$VCSH bar add c d
	$VCSH bar commit -m 'c d'

	run $VCSH list-tracked
	assert "$status" -eq 0
	assert "$output" = "$(printf '%s\n' "$HOME/a" "$HOME/b" "$HOME/c" "$HOME/d")"
}

@test "list-tracked lists files from specified repo" {
	$VCSH init foo
	$VCSH init bar

	touch a b c d e
	$VCSH foo add a b
	$VCSH foo commit -m 'a b'
	$VCSH bar add c d
	$VCSH bar commit -m 'c d'

	run $VCSH list-tracked foo
	assert "$status" -eq 0
	assert "$output" = "$(printf '%s\n' "$HOME/a" "$HOME/b")"

	run $VCSH list-tracked bar
	assert "$status" -eq 0
	assert "$output" = "$(printf '%s\n' "$HOME/c" "$HOME/d")"
}

@test "list-tracked orders files by path" {
	$VCSH init foo
	$VCSH init bar

	touch a b c d e
	$VCSH foo add a d
	$VCSH foo commit -m 'a d'
	$VCSH bar add b e
	$VCSH bar commit -m 'b e'

	run $VCSH list-tracked
	assert "$status" -eq 0
	assert "$output" = "$(printf '%s\n' "$HOME/a" "$HOME/b" "$HOME/d" "$HOME/e")"
}

@test "list-tracked does not repeat multiple-tracked files" {
	$VCSH init foo
	$VCSH init bar

	touch a b
	$VCSH foo add a b
	$VCSH foo commit -m 'a b'
	$VCSH bar add a b
	$VCSH bar commit -m 'a b'

	run $VCSH list-tracked
	assert "$status" -eq 0
	assert "$output" = "$(printf '%s\n' "$HOME/a" "$HOME/b")"
}

@test "list-tracked accepts each repo for multiple-tracked files" {
	$VCSH init foo
	$VCSH init bar

	touch a b
	$VCSH foo add a b
	$VCSH foo commit -m 'a b'
	$VCSH bar add a b
	$VCSH bar commit -m 'a b'

	run $VCSH list-tracked foo
	assert "$status" -eq 0
	assert "$output" = "$(printf '%s\n' "$HOME/a" "$HOME/b")"

	run $VCSH list-tracked bar
	assert "$status" -eq 0
	assert "$output" = "$(printf '%s\n' "$HOME/a" "$HOME/b")"
}

@test "list-tracked-by requires an argument" {
	! $VCSH list-tracked-by || false
}

@test "list-tracked-by fails if argument is not a repo" {
	skip "BUG"

	! $VCSH list-tracked-by nope || false
}

@test "list-tracked-by lists files from specified repo" {
	$VCSH init foo
	$VCSH init bar

	touch a b c d e
	$VCSH foo add a b
	$VCSH foo commit -m 'a b'
	$VCSH bar add c d
	$VCSH bar commit -m 'c d'

	run $VCSH list-tracked-by foo
	assert "$status" -eq 0
	assert "$output" = "$(printf '%s\n' "$HOME/a" "$HOME/b")"

	run $VCSH list-tracked-by bar
	assert "$status" -eq 0
	assert "$output" = "$(printf '%s\n' "$HOME/c" "$HOME/d")"
}
