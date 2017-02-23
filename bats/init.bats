#!/usr/bin/env bats

load environment

@test "Init command succeeds" {
	$VCSH init foo
}

@test "Init command takes exactly one parameter" {
	! $VCSH init
	! $VCSH init foo bar
	$VCSH init baz
}

@test "Init command fails if repository already exists" {
	$VCSH init exists
	! $VCSH init exists
}

@test "Init command respects alternate \$VCSH_REPO_D" {
	VCSH_REPO_D="$PWD/foo" $VCSH init samename
	VCSH_REPO_D="$PWD/bar" $VCSH init samename
}

@test "Init command respects alternate \$XDG_CONFIG_HOME" {
	XDG_CONFIG_HOME="$PWD/foo" $VCSH init samename
	XDG_CONFIG_HOME="$PWD/bar" $VCSH init samename
}

@test "Init command respects alternate \$HOME" {
	HOME="$PWD/foo" $VCSH init samename
	HOME="$PWD/bar" $VCSH init samename
}

@test "Init command fails if directories cannot be created" {
	mkdir ro
	chmod a-w ro
	! HOME="$PWD/ro" $VCSH init foo
}

@test "Init command can be abbreviated 'ini'/'in'" {
	$VCSH ini test1
	$VCSH in test2

	run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = $'test1\ntest2' ]
}

@test "\$VCSH_REPO_D overrides \$XDG_CONFIG_HOME and \$HOME for init" {
	HOME="$PWD/foo" $VCSH init samename1
	XDG_CONFIG_HOME="$PWD/bar" $VCSH init samename2

	HOME="$PWD/foo" XDG_CONFIG_HOME="$PWD/bar" VCSH_REPO_D="$PWD/baz" $VCSH init samename1
	HOME="$PWD/foo" XDG_CONFIG_HOME="$PWD/bar" VCSH_REPO_D="$PWD/baz" $VCSH init samename2
}

@test "\$XDG_CONFIG_HOME overrides \$HOME for init" {
	HOME="$PWD/foo" $VCSH init samename
	HOME="$PWD/foo" XDG_CONFIG_HOME="$PWD/bar" $VCSH init samename
}

@test "Init command marks repository with vcsh.vcsh=true" {
	# Too internal to implementation?  If another command verifies
	# vcsh.vcsh, use that instead of git config.

	$VCSH init test1

	run $VCSH run test1 git config vcsh.vcsh
	[ "$status" -eq 0 ]
	[ "$output" = "true" ]
}

@test "Files created by init are not readable by other users" {
	# verifies commit e220a61
	$VCSH init foo
	run find "$PWD" -type f -perm /g+rwx,o+rwx
	[ "$output" = '' ]
}

@test "Init command adds matching gitignore.d files" {
	mkdir -p .gitattributes.d .gitignore.d
	touch .gitattributes.d/test1 .gitignore.d/test1

	VCSH_GITIGNORE=exact $VCSH init test1
	$VCSH status test1 | grep -Fqx 'A  .gitignore.d/test1'
}

@test "Init command creates new Git repository" {
	run num_gitrepos "$PWD"
	[ "$output" = '0' ]

	for i in $(seq 5); do
		$VCSH init "test$i"
		run num_gitrepos "$PWD"
		[ "$output" = "$i" ]
	done
}

@test "VCSH_GITIGNORE variable is validated" {
	! VCSH_GITIGNORE=x $VCSH init foo
	! VCSH_GITIGNORE=nonsense $VCSH init foo
	! VCSH_GITIGNORE=fhqwhgads $VCSH init foo
}

@test "Init command sets core.excludesfile with VCSH_GITIGNORE=exact" {
	# XXX test instead by making sure files are actually excluded, not by
	# reading config option
	VCSH_GITIGNORE=exact $VCSH init test1
	$VCSH run test1 git config core.excludesfile
}

@test "Init command sets core.excludesfile with VCSH_GITIGNORE=recursive" {
	# XXX test instead by making sure files are actually excluded, not by
	# reading config option
	VCSH_GITIGNORE=recursive $VCSH init test1
	$VCSH run test1 git config core.excludesfile
}

@test "Init command does not set core.excludesfile with VCSH_GITIGNORE=none" {
	VCSH_GITIGNORE=none $VCSH init test1
	! $VCSH run test1 git config core.excludesfile
}

@test "Init command sets core.attributesfile with VCSH_GITATTRIBUTES!=none" {
	VCSH_GITATTRIBUTES=whatever $VCSH init test1
	$VCSH run test1 git config core.attributesfile
}

@test "Init command does not set core.attributesfile with VCSH_GITATTRIBUTES=none" {
	VCSH_GITATTRIBUTES=none $VCSH init test1
	! $VCSH run test1 git config core.attributesfile
}
