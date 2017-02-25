#!/usr/bin/env bats

load environment

doit() {
	echo "Yes, do as I say"
}

@test "Delete requires repo name" {
	! $VCSH delete
}

@test "Repository to be deleted must exist" {
	! $VCSH delete foo
}

@test "Delete requires confirmation" {
	$VCSH init foo

	! $VCSH delete foo < /dev/null
	run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = "foo" ]

	! echo | $VCSH delete foo
	run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = "foo" ]

	! echo no | $VCSH delete foo
	run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = "foo" ]
}

@test "Deleted repository removed from list" {
	$VCSH init foo
	$VCSH init bar
	doit | $VCSH delete foo

	run $VCSH list
	[ "$status" -eq 0 ]
	[ "$output" = "bar" ]
}

@test "Deleted repository cannot be subsequently used" {
	$VCSH init foo
	doit | $VCSH delete foo

	run $VCSH run foo echo fail
	[ "$status" -ne 0 ]
	[ "$output" != "fail" ]
}

@test "Delete lists staged files before confirmation" {
	$VCSH init foo
	touch randomtexttofind
	$VCSH foo add randomtexttofind

	: | $VCSH delete foo | grep -Fq randomtexttofind
}

@test "Delete lists committed files before confirmation" {
	$VCSH init foo
	touch randomtexttofind
	$VCSH foo add randomtexttofind
	$VCSH foo commit -m 'a'

	: | $VCSH delete foo | grep -Fq randomtexttofind
}

@test "Delete lists files staged for removal before confirmation" {
	skip "do we want this?"

	$VCSH init foo
	touch randomtexttofind
	$VCSH foo add randomtexttofind
	$VCSH foo commit -m 'a'
	$VCSH foo rm --cached randomtexttofind

	: | $VCSH delete foo | grep -Fq randomtexttofind
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
	[ ! -e b ]
	[ ! -e e ]
	[ -e a ]
	[ -e c ]
	[ -e d ]

	doit | $VCSH delete bar
	[ ! -e a ]
	[ ! -e c ]
	[ -e d ]
}

@test "Delete handles filenames with spaces properly" {
	skip "BUG"

	$VCSH init foo
	touch a b 'a b'
	$VCSH foo add 'a b'
	$VCSH foo commit -m 'a b'

	doit | $VCSH delete foo
	[ ! -e 'a b' ]
	[ -e a ]
	[ -e b ]
}

@test "Delete handles filenames with wildcard characters properly" {
	skip "BUG"

	$VCSH init foo
	touch a b '?'
	$VCSH foo add '\?'
	$VCSH foo commit -m '?'

	doit | $VCSH delete foo
	[ ! -e '?' ]
	[ -e a ]
	[ -e b ]
}

@test "Delete can be abbreviated (delet, dele, del, de)" {
	$VCSH init a
	$VCSH init b
	$VCSH init c
	$VCSH init d

	doit | $VCSH delet a
	! $VCSH list | grep -Fqx a

	doit | $VCSH dele b
	! $VCSH list | grep -Fqx b

	doit | $VCSH del c
	! $VCSH list | grep -Fqx c

	doit | $VCSH de d
	! $VCSH list | grep -Fqx d
}
