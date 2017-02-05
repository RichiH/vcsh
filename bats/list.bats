load environment

@test "List command succeeds" {
	"$VCSH" list
}

@test "List command creates default support directories" {
	"$VCSH" list
	test -d .config
	test -d .config/vcsh
	test -d .config/vcsh/repo.d
	test -d .gitignore.d
}

@test "List command creates \$VCSH_REPO_D" {
	VCSH_REPO_D="$PWD/foo/bar" "$VCSH" list
	test -d foo
	test -d foo/bar
	test -d .gitignore.d
}

@test "List command creates .gitignore.d in \$VCSH_BASE" {
	VCSH_BASE="$PWD/foo/bar" "$VCSH" list
	test -d .config
	test -d .config/vcsh
	test -d .config/vcsh/repo.d
	test -d foo
	test -d foo/bar
	test -d foo/bar/.gitignore.d
}

@test "List command creates .gitignore.d with VCSH_GITIGNORE=recursive" {
	VCSH_GITIGNORE=recursive "$VCSH" list
	test -d .config
	test -d .config/vcsh
	test -d .config/vcsh/repo.d
	test -d .gitignore.d
}

@test "List command does not create .gitignore.d with VCSH_GITIGNORE=none" {
	VCSH_GITIGNORE=none "$VCSH" list
	test -d .config
	test -d .config/vcsh
	test -d .config/vcsh/repo.d
	! test -d .gitignore.d
}

@test "List command gives correct output for no repos" {
	run "$VCSH" list
	[ "$output" = '' ]
}

@test "List command gives correct output for empty repo directory" {
	# XXX should vcsh fail if this is not a Git repository?
	mkdir -p .config/vcsh/repo.d/foo.git
	run "$VCSH" list
	[ "$output" = $'foo' ]
}

@test "List command gives correct output for non-bare repo" {
	# XXX should vcsh fail if this is not a bare repository?
	mkdir -p .config/vcsh/repo.d
	git init .config/vcsh/repo.d/foo.git
	run "$VCSH" list
	[ "$output" = $'foo' ]
}

@test "List command gives correct output for one repo (git init)" {
	mkdir -p .config/vcsh/repo.d
	git init --bare .config/vcsh/repo.d/foo.git
	run "$VCSH" list
	[ "$output" = $'foo' ]
}

@test "List command gives correct output for one repo (vcsh init)" {
	"$VCSH" init foo
	run "$VCSH" list
	[ "$output" = $'foo' ]
}

@test "List command gives correct output for three repos (git init)" {
	# XXX should this fail if these are not bare repositories?
	mkdir -p .config/vcsh/repo.d
	git init --bare .config/vcsh/repo.d/foo.git
	git init --bare .config/vcsh/repo.d/bar.git
	git init --bare .config/vcsh/repo.d/baz.git
	run "$VCSH" list
	[ "$output" = $'bar\nbaz\nfoo' ]
}

@test "List command gives correct output for three repos (vcsh init)" {
	# XXX should this fail if these are not bare repositories?
	mkdir -p .config/vcsh/repo.d
	"$VCSH" init foo
	"$VCSH" init bar
	"$VCSH" init baz
	run "$VCSH" list
	[ "$output" = $'bar\nbaz\nfoo' ]
}

@test "List command only lists directories" {
	mkdir -p .config/vcsh/repo.d
	touch .config/vcsh/repo.d/foo.git
	mkfifo .config/vcsh/repo.d/bar.git

	run "$VCSH" list
	[ "$output" = '' ]

	"$VCSH" init baz
	run "$VCSH" list
	[ "$output" = 'baz' ]
}

@test "List command only lists directories ending in '.git'" {
	mkdir -p .config/vcsh/repo.d
	git init --bare .config/vcsh/repo.d/foo
	git init --bare .config/vcsh/repo.d/bar
	git init --bare .config/vcsh/repo.d/baz.git

	run "$VCSH" list
	[ "$output" = 'baz' ]
}

@test "List command does not list unreadable repos" {
	"$VCSH" init foo

	run "$VCSH" list
	[ "$output" = 'foo' ]

	chmod a-r .config/vcsh/repo.d/foo.git
	run "$VCSH" list
	[ "$output" = '' ]
}

@test "List command respects \$VCSH_REPO_D (git init)" {
	mkdir -p foo/bar
	git init --bare foo/bar/hello.git

	VCSH_REPO_D="$PWD/foo/bar" run "$VCSH" list
	[ "$output" = 'hello' ]
}

@test "List command respects \$VCSH_REPO_D (vcsh init)" {
	mkdir -p foo/bar
	VCSH_REPO_D="$PWD/foo/bar" "$VCSH" init hello

	VCSH_REPO_D="$PWD/foo/bar" run "$VCSH" list
	[ "$output" = 'hello' ]
}
