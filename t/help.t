#!/usr/bin/env bats

load environment

@test "Help command succeeds" {
	skip "BUG: help command fails"
	$VCSH help
}
@test "Help command writes to stderr and not stdout" {
	$VCSH help 2>&1 1>/dev/null |
		grep -q ''
	! $VCSH help 2>/dev/null |
		grep -q '' || false
}
@test "Help command prints usage on first line" {
	run $VCSH help
	[[ "$output" = 'usage: '* ]]
}

@test "Help command can be abbreviated (hel, he)" {
	skip "BUG: help command fails"
	run $VCSH help
	local good=$output

	run $VCSH hel
	assert "$status" -eq 0
	assert "$output" = "$good"

	run $VCSH he
	assert "$status" -eq 0
	assert "$output" = "$good"
}

# Help should explain each command.  (Note: adjust the help_check function if
# the format of help output changes.)
help_check() {
	$VCSH help 2>&1 |
		grep -q "^   $1\\b"
}

@test "Help text includes clone command" { help_check clone; }
@test "Help text includes commit command" { help_check commit; }
@test "Help text includes delete command" { help_check delete; }
@test "Help text includes enter command" { help_check enter; }
@test "Help text includes foreach command" { help_check foreach; }
@test "Help text includes help command" { help_check help; }
@test "Help text includes init command" { help_check init; }
@test "Help text includes list command" { help_check list; }
@test "Help text includes list-tracked command" { help_check list-tracked; }
# list-tracked-by is deprecated, not shown in help
@test "Help text includes list-untracked command" { help_check list-untracked; }
@test "Help text includes pull command" { help_check pull; }
@test "Help text includes push command" { help_check push; }
@test "Help text includes rename command" { help_check rename; }
@test "Help text includes run command" { help_check run; }
@test "Help text includes status command" { help_check status; }
@test "Help text includes upgrade command" { help_check upgrade; }
@test "Help text includes version command" { help_check version; }
@test "Help text includes which command" { help_check which; }
@test "Help text includes write-gitignore command" { help_check write-gitignore; }
