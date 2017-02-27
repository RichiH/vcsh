#!/usr/bin/env bats

load environment

@test "Clone requires a remote" {
	run $VCSH clone
	assert "$status" -eq 1
}

@test "Clone uses existing repo name by default" {
	$VCSH clone "$TESTREPO"
	$VCSH list
	run $VCSH list
	assert "$status" -eq 0
	assert "$output" = "$TESTREPONAME"
}

@test "Clone honors specified repo name" {
	$VCSH clone "$TESTREPO" foo
	run $VCSH list
	assert "$status" -eq 0
	assert "$output" = "foo"
}

@test "Clone uses given remote HEAD by default" {
	$VCSH clone "$TESTREPO"
	run git ls-remote "$TESTREPO" HEAD
	correct=${output::40}

	run $VCSH run "$TESTREPONAME" git rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$correct"
}

@test "Clone honors -b option before remote" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO"
	run git ls-remote "$TESTREPO" "$TESTBR1"
	correct=${output::40}

	run $VCSH run "$TESTREPONAME" git rev-parse "$TESTBR1"
	assert "$status" -eq 0
	assert "$output" = "$correct"
}

@test "Clone honors -b option before remote and repo name" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO" foo
	run git ls-remote "$TESTREPO" "$TESTBR1"
	correct=${output::40}

	run $VCSH run foo git rev-parse "$TESTBR1"
	assert "$status" -eq 0
	assert "$output" = "$correct"
}

@test "Clone honors -b option after remote" {
	$VCSH clone "$TESTREPO" -b "$TESTBR1"
	run git ls-remote "$TESTREPO" "$TESTBR1"
	correct=${output::40}

	run $VCSH run "$TESTREPONAME" git rev-parse "$TESTBR1"
	assert "$status" -eq 0
	assert "$output" = "$correct"
}

@test "Clone honors -b option between remote and repo name" {
	$VCSH clone "$TESTREPO" -b "$TESTBR1" foo
	run git ls-remote "$TESTREPO" "$TESTBR1"
	correct=${output::40}

	run $VCSH run foo git rev-parse "$TESTBR1"
	assert "$status" -eq 0
	assert "$output" = "$correct"
}

@test "Clone honors -b option after repo name" {
	$VCSH clone "$TESTREPO" foo -b "$TESTBR1"
	run git ls-remote "$TESTREPO" "$TESTBR1"
	correct=${output::40}

	run $VCSH run foo git rev-parse "$TESTBR1"
	assert "$status" -eq 0
	assert "$output" = "$correct"
}

@test "Clone -b option clones only one branch" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO"
	run $VCSH run "$TESTREPONAME" git branch
	assert "${#lines[@]}" -eq 1
}

@test "Clone can be abbreviated (clon, clo, cl)" {
	$VCSH clon "$TESTREPO" a
	$VCSH clo -b "$TESTBR1" "$TESTREPO" b
	$VCSH cl -b "$TESTBR2" "$TESTREPO" c

	run $VCSH list
	assert "$status" -eq 0
	assert "$output" = "$(printf 'a\nb\nc')"
}
