#!/usr/bin/env bats

load environment

doit() {
	echo "Yes, do as I say"
}

@test "Delete requires repo name" {
	! $VCSH delete || false
}

@test "Repository to be deleted must exist" {
	! $VCSH delete foo || false
}

@test "Delete requires confirmation" {
	$VCSH init foo

	! $VCSH delete foo < /dev/null || false
	run $VCSH list
	assert "$status" -eq 0
	assert "$output" = "foo"

	! echo | $VCSH delete foo || false
	run $VCSH list
	assert "$status" -eq 0
	assert "$output" = "foo"

	! echo no | $VCSH delete foo || false
	run $VCSH list
	assert "$status" -eq 0
	assert "$output" = "foo"
}

@test "Deleted repository removed from list" {
	$VCSH init foo
	$VCSH init bar
	doit | $VCSH delete foo

	run $VCSH list
	assert "$status" -eq 0
	assert "$output" = "bar"
}

@test "Deleted repository not in status" {
	$VCSH init foo
	doit | $VCSH delete foo

	run $VCSH status
	assert "$status" -eq 0
	assert "$output" = ""
}

@test "Deleted repository cannot be subsequently used" {
	$VCSH init foo
	doit | $VCSH delete foo

	run $VCSH run foo echo fail
	assert "$status" -ne 0
	assert "$output" != "fail"
}

@test "Delete lists staged files before confirmation" {
	$VCSH init foo
	touch randomtexttofind
	$VCSH foo add randomtexttofind

	: | $VCSH delete foo | assert_grep -F randomtexttofind
}

@test "Delete lists committed files before confirmation" {
	$VCSH init foo
	touch randomtexttofind
	$VCSH foo add randomtexttofind
	$VCSH foo commit -m 'a'

	: | $VCSH delete foo | assert_grep -F randomtexttofind
}

@test "Delete lists files staged for removal before confirmation" {
	skip "do we want this?"

	$VCSH init foo
	touch randomtexttofind
	$VCSH foo add randomtexttofind
	$VCSH foo commit -m 'a'
	$VCSH foo rm --cached randomtexttofind

	: | $VCSH delete foo | assert_grep -F randomtexttofind
}

@test "Delete removes corresponding files" {
	$VCSH init foo
	$VCSH init bar

	touch a b c d e
	$VCSH foo add b e
	$VCSH foo commit -m 'b e'
	$VCSH bar add a c
	$VCSH bar commit -m 'a c'

	doit | $VCSH delete foo
	assert_file ! -e b
	assert_file ! -e e
	assert_file -e a
	assert_file -e c
	assert_file -e d

	doit | $VCSH delete bar
	assert_file ! -e a
	assert_file ! -e c
	assert_file -e d
}

@test "Delete handles filenames with spaces properly" {
	skip "BUG"

	$VCSH init foo
	touch a b 'a b'
	$VCSH foo add 'a b'
	$VCSH foo commit -m 'a b'

	doit | $VCSH delete foo
	assert_file ! -e 'a b'
	assert_file -e a
	assert_file -e b
}

@test "Delete handles filenames with wildcard characters properly" {
	skip "BUG"

	$VCSH init foo
	touch a b '?'
	$VCSH foo add '\?'
	$VCSH foo commit -m '?'

	doit | $VCSH delete foo
	assert_file ! -e '?'
	assert_file -e a
	assert_file -e b
}

@test "Delete can be abbreviated (delet, dele, del, de)" {
	$VCSH init a
	$VCSH init b
	$VCSH init c
	$VCSH init d

	doit | $VCSH delet a
	! $VCSH list | assert_grep -Fx a || false

	doit | $VCSH dele b
	! $VCSH list | assert_grep -Fx b || false

	doit | $VCSH del c
	! $VCSH list | assert_grep -Fx c || false

	doit | $VCSH de d
	! $VCSH list | assert_grep -Fx d || false
}
