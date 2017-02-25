#!/usr/bin/env bats

load environment

@test "Foreach requires an argument" {
	! $VCSH foreach
}

@test "Foreach does nothing if no repositories exist" {
	run $VCSH foreach version
	[ "$status" -eq 0 ]
	[ "$output" = "" ]
}

@test "Foreach executes Git command inside each repository" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO" foo
	$VCSH clone -b "$TESTBR2" "$TESTREPO" bar

	rev1=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1)
	rev2=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR2" | cut -f 1)

	run $VCSH foreach rev-parse HEAD
	[ "$status" -eq 0 ]
	[ "$output" = $'bar:\n'"$rev2"$'\nfoo:\n'"$rev1" ]
}

@test "Foreach supports -g for non-Git commands" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO" foo
	$VCSH clone -b "$TESTBR2" "$TESTREPO" bar

	rev1=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1)
	rev2=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR2" | cut -f 1)

	run $VCSH foreach -g echo test-output
	[ "$status" -eq 0 ]
	[ "$output" = $'bar:\ntest-output\nfoo:\ntest-output' ]
}
