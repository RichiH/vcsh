#!/usr/bin/env bats

load environment

@test "Run executes command inside specific repository" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO" foo
	$VCSH clone -b "$TESTBR2" "$TESTREPO" bar

	rev1=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1)
	rev2=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR2" | cut -f 1)

	run $VCSH run foo git rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev1"

	run $VCSH run bar git rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev2"
}

@test "Run implied if no explicit command specified" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO" foo
	$VCSH clone -b "$TESTBR2" "$TESTREPO" bar

	rev1=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1)
	rev2=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR2" | cut -f 1)

	run $VCSH foo rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev1"

	run $VCSH bar rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev2"
}

@test "Run can be abbreviated (ru)" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO" foo

	rev1=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1)

	run $VCSH ru foo git rev-parse HEAD
	assert "$status" -eq 0
	assert "$output" = "$rev1"
}

@test "Run returns exit status of subcommand" {
	$VCSH init foo

	run $VCSH run foo sh -c 'exit 104'
	assert "$status" -eq 104

	run $VCSH run foo sh -c 'exit 42'
	assert "$status" -eq 42

	run $VCSH run foo sh -c 'exit 93'
	assert "$status" -eq 93
}

@test "Enter executes inside specific repository" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO" foo
	$VCSH clone -b "$TESTBR2" "$TESTREPO" bar

	rev1=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1)
	rev2=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR2" | cut -f 1)

	echo 'git rev-parse HEAD > rev' | SHELL=/bin/sh $VCSH enter foo
	assert "$(cat rev)" = "$rev1"

	echo 'git rev-parse HEAD > rev' | SHELL=/bin/sh $VCSH enter bar
	assert "$(cat rev)" = "$rev2"
}

@test "Enter executes \$SHELL inside repository" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO" foo

	rev1=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1)
	SHELL='git rev-parse HEAD' run $VCSH enter foo
	assert "$status" -eq 0
	assert "$output" = "$rev1"
}

@test "Enter implied for single non-command argument" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO" foo
	$VCSH clone -b "$TESTBR2" "$TESTREPO" bar

	rev1=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1)
	rev2=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR2" | cut -f 1)

	echo 'git rev-parse HEAD > rev' | SHELL=/bin/sh $VCSH foo
	assert "$(cat rev)" = "$rev1"

	echo 'git rev-parse HEAD > rev' | SHELL=/bin/sh $VCSH bar
	assert "$(cat rev)" = "$rev2"
}

@test "Enter returns exit status of subshell" {
	skip "BUG: enter does not pass on subshell's exit status"
	$VCSH init foo

	echo 'exit 104' | SHELL=/bin/sh $VCSH enter foo
	assert "$?" -eq 104

	echo 'exit 42' | SHELL=/bin/sh $VCSH enter foo
	assert "$?" -eq 42

	echo 'exit 93' | SHELL=/bin/sh $VCSH enter foo
	assert "$?" -eq 93
}

@test "Enter can be abbreviated (ente, ent, en)" {
	$VCSH clone -b "$TESTBR1" "$TESTREPO" foo

	rev1=$(git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1)

	echo 'git rev-parse HEAD >> output' | SHELL=/bin/sh $VCSH ente foo
	echo 'git rev-parse HEAD >> output' | SHELL=/bin/sh $VCSH ent foo
	echo 'git rev-parse HEAD >> output' | SHELL=/bin/sh $VCSH en foo

	assert "$(cat output)" = "$(printf '%s\n%s\n%s' "$rev1" "$rev1" "$rev1")"
}
