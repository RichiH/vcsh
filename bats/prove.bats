load environment

@test "100-init.t" {
	run "$VCSH" status
	[ "$status" -eq 0 ]
	[ "$output" = "" ]

	run "$VCSH" init test1
	[ "$status" -eq 0 ]
	[ "$output" = "Initialized empty shared Git repository in $HOME/.config/vcsh/repo.d/test1.git/" ]

	run "$VCSH" status
	echo "'$output'"
	[ "$status" -eq 0 ]
	[ "$output" = 'test1:' ]

	cd "$HOME/.config/vcsh/repo.d/test1.git/"
	test -f 'HEAD'
	test -f 'config'
	test -f 'description'
	test -d 'hooks'
	test -d 'info'
	test -d 'objects'
	test -d 'refs'

	test -f 'hooks/applypatch-msg.sample'
	test -f 'hooks/commit-msg.sample'
	test -f 'hooks/post-update.sample'
	test -f 'hooks/pre-applypatch.sample'
	test -f 'hooks/pre-commit.sample'
	test -f 'hooks/pre-push.sample'
	test -f 'hooks/pre-rebase.sample'
	test -f 'hooks/prepare-commit-msg.sample'
	test -f 'hooks/update.sample'

	test -f 'info/exclude'

	test -d 'objects/info'
	test -d 'objects/pack'

	test -d 'refs/heads'
	test -d 'refs/tags'
}

@test "300-add.t" {
	"$VCSH" init test1
	"$VCSH" init test2

	touch 'a'
	"$VCSH" test2 add 'a'

	run "$VCSH" status
	[ "$status" -eq 0 ]
	[ "$output" = $'test1:\n\ntest2:\nA  a' ]

	run "$VCSH" status --terse
	[ "$status" -eq 0 ]
	[ "$output" = $'test2:\nA  a' ]
}

@test "950-delete.t" {
	"$VCSH" init test1
	echo 'Yes, do as I say' | run "$VCSH" delete test1

	run "$VCSH" status
	[ "$status" -eq 0 ]
	[ "$output" = '' ]
}
