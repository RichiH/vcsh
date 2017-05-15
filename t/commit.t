#!/usr/bin/env bats

load environment

@test "commit works with no repos" {
	run $VCSH commit
	assert "$status" -eq 0
	assert "$output" = ""
}

@test "commit works with single repo" {
	skip "BUG: commit is broken"

	$VCSH init foo

	touch a
	$VCSH foo add a
	run $VCSH commit -m 'a'
	assert "$status" -eq 0
	# XXX Is printing a trailing space really intended?
	assert "$output" = "foo: "

	run $VCSH foo rev-list HEAD --count
	assert "$status" -eq 0
	assert "$output" = "1"
}

@test "commit works with multiple repos" {
	skip "BUG: commit is broken"

	$VCSH init foo
	$VCSH init bar

	touch a b
	$VCSH foo add a
	$VCSH bar add b
	run $VCSH commit -m 'ab'
	assert "$status" -eq 0
	# XXX Is printing a trailing space and blank line really intended?
	assert "$output" = "$(printf 'bar: \n\nfoo: ')"

	$VCSH foo log --oneline | assert_grep -x '....... ab'
	$VCSH bar log --oneline | assert_grep -x '....... ab'
}

@test "commit can handle arguments with spaces" {
	skip "BUG: commit is broken"

	$VCSH init foo
	$VCSH init bar

	touch a b
	$VCSH foo add a
	$VCSH bar add b
	$VCSH commit -m 'log message'

	$VCSH foo log --oneline | assert_grep -x '....... log message'
	$VCSH bar log --oneline | assert_grep -x '....... log message'
}

@test "commit works even if not all repos have changes" {
	skip "BUG: commit is broken"

	$VCSH init foo
	$VCSH init bar

	touch a b
	$VCSH foo add a
	$VCSH commit -m 'part1'

	$VCSH bar add b
	$VCSH commit -m 'part2'

	$VCSH foo log --oneline | assert_grep -x '....... part1'
	$VCSH bar log --oneline | assert_grep -x '....... part2'
}

@test "commit not affected by existing \$VCSH_COMMAND_RETURN_CODE" {
	skip "BUG"

	VCSH_COMMAND_RETURN_CODE=1
	export VCSH_COMMAND_RETURN_CODE

	run $VCSH commit
	assert "$status" -eq 0
	assert "$output" = ""
}
