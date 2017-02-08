load environment

@test "Rename works on empty repository" {
	$VCSH init foo
	$VCSH rename foo bar

	run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'bar' ]
}

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
