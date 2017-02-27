#!/usr/bin/env bats

load environment

@test "push works with no repositories" {
	run $VCSH push
	assert "$status" -eq 0
	assert "$output" = ""
}

@test "push succeeds if up-to-date" {
	git clone --bare "$TESTREPO" upstream.git

	$VCSH clone upstream.git foo
	$VCSH foo config push.default simple
	run $VCSH push
	assert "$status" -eq 0
	assert "$output" = "foo: Everything up-to-date"
}

@test "push works with one repository" {
	git clone --bare "$TESTREPO" upstream.git

	$VCSH clone upstream.git foo
	$VCSH foo config push.default simple
	$VCSH foo commit --allow-empty -m 'empty'
	run $VCSH foo rev-parse HEAD
	rev=$output

	$VCSH push

	run git -C upstream.git rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev"
}

@test "push works with multiple repositories" {
	git clone --bare -b "$TESTBR1" "$TESTREPO" upstream1.git
	git clone --bare -b "$TESTBR2" "$TESTREPO" upstream2.git

	$VCSH clone -b "$TESTBR1" upstream1.git foo
	$VCSH foo config push.default simple
	$VCSH clone -b "$TESTBR2" upstream2.git bar
	$VCSH bar config push.default simple

	$VCSH foo commit --allow-empty -m 'empty'
	run $VCSH foo rev-parse HEAD
	rev1=$output

	$VCSH bar commit --allow-empty -m 'empty'
	run $VCSH bar rev-parse HEAD
	rev2=$output

	$VCSH push

	run git -C upstream1.git rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev1"
	run git -C upstream2.git rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev2"
}

@test "push fails if first push fails" {
	skip "BUG"

	git clone --bare -b "$TESTBR1" "$TESTREPO" upstream1.git
	git clone --bare -b "$TESTBR2" "$TESTREPO" upstream2.git

	$VCSH clone -b "$TESTBR1" upstream1.git a
	$VCSH foo config push.default simple
	$VCSH clone -b "$TESTBR2" upstream2.git b
	$VCSH bar config push.default simple

	rm -rf upstream1.git
	$VCSH b commit --allow-empty -m 'empty'

	! $VCSH push
}

@test "push fails if last push fails" {
	git clone --bare -b "$TESTBR1" "$TESTREPO" upstream1.git
	git clone --bare -b "$TESTBR2" "$TESTREPO" upstream2.git

	$VCSH clone -b "$TESTBR1" upstream1.git a
	$VCSH a config push.default simple
	$VCSH clone -b "$TESTBR2" upstream2.git b
	$VCSH b config push.default simple

	$VCSH a commit --allow-empty -m 'empty'
	rm -rf upstream2.git

	! $VCSH push
}
