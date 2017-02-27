#!/usr/bin/env bats

load environment

@test "pull works with no repositories" {
	run $VCSH pull
	assert "$status" -eq 0
	assert "$output" = ""
}

@test "pull succeeds if up-to-date" {
	git clone "$TESTREPO" upstream

	$VCSH clone upstream foo
	run $VCSH pull
	assert "$status" -eq 0
	assert "$output" = "foo: Already up-to-date."
}

@test "pull works with one repository" {
	git clone "$TESTREPO" upstream

	$VCSH clone upstream foo
	git -C upstream commit --allow-empty -m 'empty'
	run git -C upstream rev-parse HEAD
	rev=$output

	$VCSH pull
	run $VCSH foo rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev"
}

@test "pull works with multiple repositories" {
	git clone -b "$TESTBR1" "$TESTREPO" upstream1
	git clone -b "$TESTBR2" "$TESTREPO" upstream2

	$VCSH clone -b "$TESTBR1" upstream1 foo
	$VCSH clone -b "$TESTBR2" upstream2 bar

	git -C upstream1 commit --allow-empty -m 'empty'
	run git -C upstream1 rev-parse HEAD
	rev1=$output

	git -C upstream2 commit --allow-empty -m 'empty'
	run git -C upstream2 rev-parse HEAD
	rev2=$output

	$VCSH pull

	run $VCSH foo rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev1"
	run $VCSH bar rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev2"
}

@test "pull fails if first pull fails" {
	skip "BUG"

	git clone -b "$TESTBR1" "$TESTREPO" upstream1
	git clone -b "$TESTBR2" "$TESTREPO" upstream2

	$VCSH clone -b "$TESTBR1" upstream1 a
	$VCSH clone -b "$TESTBR2" upstream2 b

	rm -rf upstream1
	git -C upstream2 commit --allow-empty -m 'empty'

	! $VCSH pull
}

@test "pull fails if last pull fails" {
	git clone -b "$TESTBR1" "$TESTREPO" upstream1
	git clone -b "$TESTBR2" "$TESTREPO" upstream2

	$VCSH clone -b "$TESTBR1" upstream1 a
	$VCSH clone -b "$TESTBR2" upstream2 b

	git -C upstream1 commit --allow-empty -m 'empty'
	rm -rf upstream2

	! $VCSH pull
}
