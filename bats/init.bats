load environment

@test "Init command succeeds" {
	"$VCSH" init foo
}

@test "Debug output for init command includes git version" {
	"$VCSH" -d init foo | grep -F "$GITVERSION"
}

@test "Init command takes exactly one parameter" {
	! "$VCSH" init
	! "$VCSH" init foo bar
	"$VCSH" init baz
}

@test "Init command creates default support directories" {
	"$VCSH" init foo
	test -d .config
	test -d .config/vcsh
	test -d .config/vcsh/repo.d
	test -d .gitignore.d
}

@test "Init command creates correct Git repository" {
	"$VCSH" init test1

	cd "$HOME"
	test -d .config
	test -d .config/vcsh
	test -d .config/vcsh/repo.d
	test -d .config/vcsh/repo.d/test1.git

	git rev-parse --resolve-git-dir "$HOME/.config/vcsh/repo.d/test1.git"
}

@test "Init command creates \$VCSH_REPO_D" {
	VCSH_REPO_D="$PWD/foo/bar" "$VCSH" init foo
	test -d foo
	test -d foo/bar
	test -d .gitignore.d
}

@test "Init command creates .gitignore.d with VCSH_GITIGNORE=exact" {
	VCSH_GITIGNORE=exact "$VCSH" init foo
	test -d .gitignore.d
}

@test "Init command creates .gitignore.d with VCSH_GITIGNORE=recursive" {
	VCSH_GITIGNORE=recursive "$VCSH" init foo
	test -d .gitignore.d
}

@test "Init command does not create .gitignore.d with VCSH_GITIGNORE=none" {
	VCSH_GITIGNORE=none "$VCSH" init foo
	! test -d .gitignore.d
}

@test "Init command fails with invalid VCSH_GITIGNORE" {
	! VCSH_GITIGNORE=nonsense "$VCSH" init foo
}

@test "Init command creates .gitignore.d in \$VCSH_BASE" {
	VCSH_BASE="$PWD/foo/bar" "$VCSH" init foo
	test -d .config
	test -d .config/vcsh
	test -d .config/vcsh/repo.d
	test -d foo
	test -d foo/bar
	test -d foo/bar/.gitignore.d
}
