#!/usr/bin/env bats

load environment

@test "300-add.t" {
	$VCSH init test1
	$VCSH init test2

	touch 'a'
	$VCSH test2 add 'a'

	run $VCSH status
	assert "$status" -eq 0
	assert "$output" = $'test1:\n\ntest2:\nA  a'

	run $VCSH status --terse
	assert "$status" -eq 0
	assert "$output" = $'test2:\nA  a'
}
