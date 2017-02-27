#!/usr/bin/env bats

load environment

@test "Which command requires exactly one parameter" {
	! $VCSH which
	! $VCSH which foo bar
}

@test "Which command does not accept an empty parameter" {
	! $VCSH which ''
}

@test "Which command fails if no repositories" {
	! $VCSH which nope
}

@test "Which command fails if pattern not found" {
	$VCSH init foo

	touch a
	$VCSH foo add a
	$VCSH foo commit -m 'a'

	! $VCSH which nope
}

@test "Which command matches exact filename" {
	$VCSH init foo

	touch hello testfile
	$VCSH foo add hello testfile
	$VCSH foo commit -m 'testfile'

	run $VCSH which testfile
	assert "$status" -eq 0
	assert "$output" = "foo: testfile"
}

@test "Which command matches entire path" {
	$VCSH init foo

	mkdir -p dir
	touch hello dir/testfile
	$VCSH foo add hello dir/testfile
	$VCSH foo commit -m 'dir/testfile'

	run $VCSH which dir/testfile
	assert "$status" -eq 0
	assert "$output" = "foo: dir/testfile"
}

@test "Which command matches filename within subdirectory" {
	$VCSH init foo

	mkdir -p dir
	touch hello dir/testfile
	$VCSH foo add hello dir/testfile
	$VCSH foo commit -m 'dir/testfile'

	run $VCSH which testfile
	assert "$status" -eq 0
	assert "$output" = "foo: dir/testfile"
}

@test "Which command matches directory path component" {
	$VCSH init foo

	mkdir -p dir/subd
	touch hello dir/subd/testfile
	$VCSH foo add hello dir/subd/testfile
	$VCSH foo commit -m 'dir/subd/testfile'

	run $VCSH which subd
	assert "$status" -eq 0
	assert "$output" = "foo: dir/subd/testfile"
}

@test "Which command matches partial filename" {
	$VCSH init foo

	mkdir -p dir/subd
	touch hello dir/subd/testfile
	$VCSH foo add hello dir/subd/testfile
	$VCSH foo commit -m 'dir/subd/testfile'

	run $VCSH which estf
	assert "$status" -eq 0
	assert "$output" = "foo: dir/subd/testfile"
}

@test "Which command matches partial path component across slash" {
	$VCSH init foo

	mkdir -p dir/subd
	touch hello dir/subd/testfile
	$VCSH foo add hello dir/subd/testfile
	$VCSH foo commit -m 'dir/subd/testfile'

	run $VCSH which bd/te
	assert "$status" -eq 0
	assert "$output" = "foo: dir/subd/testfile"
}

@test "Which command matches using POSIX BRE" {
	$VCSH init foo

	touch calor color colour 'colou?r'
	$VCSH foo add *
	$VCSH foo commit -m 'color'

	run $VCSH which 'c.lou\?r'
	assert "$status" -eq 0
	assert "$output" = "$(printf 'foo: calor\nfoo: color\nfoo: colour')"
}

@test "Which command searches all repos" {
	$VCSH init foo
	$VCSH init bar
	$VCSH init baz

	mkdir -p a b c
	touch {a,b,c}/{hello,goodbye}
	$VCSH foo add a
	$VCSH foo commit -m 'hello'
	$VCSH bar add b
	$VCSH bar commit -m 'hello'
	$VCSH baz add c
	$VCSH baz commit -m 'hello'

	run $VCSH which hello
	assert "$status" -eq 0
	assert "$output" = "$(printf 'bar: b/hello\nbaz: c/hello\nfoo: a/hello')"
}
