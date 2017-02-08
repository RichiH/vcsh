load environment

@test "List command correct for no repositories" {
	run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = '' ]
}

@test "List command displays inited repository" {
	$VCSH init test1
	run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'test1' ]
}

@test "List command displays cloned repository" {
	$VCSH clone "$TESTREPO" test1
	run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'test1' ]
}

@test "List command displays multiple repositories" {
	$VCSH init foo
	$VCSH init bar
	$VCSH init baz
	run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = $'bar\nbaz\nfoo' ]
}

@test "List command respects \$VCSH_REPO_D" {
	VCSH_REPO_D="$PWD/foo" $VCSH init test1
	VCSH_REPO_D="$PWD/bar" $VCSH init test2

	VCSH_REPO_D="$PWD/foo" run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'test1' ]

	VCSH_REPO_D="$PWD/bar" run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'test2' ]
}

@test "List command respects \$XDG_CONFIG_HOME" {
	XDG_CONFIG_HOME="$PWD/foo" $VCSH init test1
	XDG_CONFIG_HOME="$PWD/bar" $VCSH init test2

	XDG_CONFIG_HOME="$PWD/foo" run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'test1' ]

	XDG_CONFIG_HOME="$PWD/bar" run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'test2' ]
}

@test "List command respects \$HOME" {
	HOME="$PWD/foo" $VCSH init test1
	HOME="$PWD/bar" $VCSH init test2

	HOME="$PWD/foo" run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'test1' ]

	HOME="$PWD/bar" run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'test2' ]
}

@test "List command prioritizes \$XDG_CONFIG_HOME over \$HOME" {
	HOME="$PWD/foo" $VCSH init correct
	HOME="$PWD/bar" $VCSH init wrong

	HOME="$PWD/bar" XDG_CONFIG_HOME="$PWD/foo/.config" run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'correct' ]
}

@test "List command prioritizes \$VCSH_REPO_D over \$HOME" {
	HOME="$PWD/foo" $VCSH init correct
	HOME="$PWD/bar" $VCSH init wrong

	HOME="$PWD/bar" VCSH_REPO_D="$PWD/foo/.config/vcsh/repo.d" run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'correct' ]
}

@test "List command prioritizes \$VCSH_REPO_D over \$XDG_CONFIG_HOME" {
	XDG_CONFIG_HOME="$PWD/foo" $VCSH init correct
	XDG_CONFIG_HOME="$PWD/bar" $VCSH init wrong

	XDG_CONFIG_HOME="$PWD/bar" VCSH_REPO_D="$PWD/foo/vcsh/repo.d" run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = 'correct' ]
}
