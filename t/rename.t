#!/usr/bin/env bats

load environment

@test "Rename requires two arguments" {
	! $VCSH rename
	! $VCSH rename foo
}

@test "Repository to be renamed must exist" {
	! $VCSH rename foo bar
}

@test "Target of rename must not already exist" {
	$VCSH init foo
	$VCSH init bar

	! $VCSH rename foo bar
}

@test "Rename works on empty repository" {
	$VCSH init foo
	$VCSH rename foo bar

	run $VCSH list
	assert "$status" -eq 0
	assert "$output" = 'bar'
}

@test "Rename works on repository with files/commits" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO" foo
	rev=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1)

	$VCSH rename foo bar
	run $VCSH bar rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev"
}

@test "Rename adopts existing .gitignore.d files under new name (bug?)" {
	$VCSH init foo

	mkdir -p .gitignore.d
	echo test > .gitignore.d/bar

	$VCSH rename foo bar
	run $VCSH bar ls-files
	assert "$status" -eq 0
	assert "$output" = ".gitignore.d/bar"
}

@test "Rename adopts existing .gitattributes.d files under new name (bug?)" {
	$VCSH init foo

	mkdir -p .gitattributes.d
	echo '* whitespace' > .gitattributes.d/bar

	$VCSH rename foo bar
	run $VCSH bar ls-files
	assert "$status" -eq 0
	assert "$output" = ".gitattributes.d/bar"
}

@test "Rename can be abbreviated (renam, rena, ren, re)" {
	$VCSH init foo

	$VCSH renam foo bar
	$VCSH rena bar baz
	$VCSH ren baz bat
	$VCSH re bat quux

	run $VCSH list
	assert "$status" -eq 0
	assert "$output" = "quux"
}
