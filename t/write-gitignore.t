#!/bin/sh

# XXX Distinction between recursive/exact for VCSH_GITIGNORE is unclear;
# currently they are equivalent because ls-files doesn't show directories.

test_description='write-gitignore command'

. ./sharness/sharness.sh
. "$SHARNESS_TEST_DIRECTORY/environment.sh"

test_expect_success 'parameter is required' \
	'test_must_fail $VCSH write-gitignore'

test_expect_success 'empty parameter not allowed' \
	'test_must_fail $VCSH write-gitignore ""'

test_expect_success 'fails if no repositories' \
	'test_must_fail $VCSH write-gitignore nope'

test_setup 'create repository "foo"' \
	'$VCSH init foo &&

	mkdir dir dir2 &&
	touch a b c dir/d dir/e dir2/f dir2/g &&
	$VCSH foo add a b dir/d &&
	$VCSH foo commit -m "commit"'

test_expect_success 'given repository must exist' \
	'test_must_fail $VCSH write-gitignore fail'

test_expect_success 'does nothing with VCSH_GITIGNORE=none' \
	'test_might_fail test_env VCSH_GITIGNORE=none $VCSH write-gitignore foo &&
	test_must_fail test -e .gitignore.d/foo'

test_expect_success 'command succeeds' \
	'$VCSH write-gitignore foo &&
	test_when_finished "rm -rf .gitignore.d/"'

test_expect_success 'current files not ignored' \
	'$VCSH write-gitignore foo &&
	test_when_finished "rm -rf .gitignore.d/"&&
	test_must_fail $VCSH foo check-ignore a &&
	test_must_fail $VCSH foo check-ignore b &&
	test_must_fail $VCSH foo check-ignore dir/d'

test_expect_success 'other existing files ignored' \
	'$VCSH write-gitignore foo &&
	test_when_finished "rm -rf .gitignore.d/"&&
	$VCSH foo check-ignore c &&
	$VCSH foo check-ignore dir/e &&
	$VCSH foo check-ignore dir2/f &&
	$VCSH foo check-ignore dir2/g'

test_expect_success 'can be abbreviated "write"' \
	'$VCSH write foo &&
	test_when_finished "rm -rf .gitignore.d/"&&
	test_must_fail $VCSH foo check-ignore a &&
	test_must_fail $VCSH foo check-ignore b &&
	test_must_fail $VCSH foo check-ignore dir/d &&
	$VCSH foo check-ignore c &&
	$VCSH foo check-ignore dir/e &&
	$VCSH foo check-ignore dir2/f &&
	$VCSH foo check-ignore dir2/g'

test_expect_success 'can be abbreviated "writ"' \
	'$VCSH writ foo &&
	test_when_finished "rm -rf .gitignore.d/"&&
	test_must_fail $VCSH foo check-ignore a &&
	test_must_fail $VCSH foo check-ignore b &&
	test_must_fail $VCSH foo check-ignore dir/d &&
	$VCSH foo check-ignore c &&
	$VCSH foo check-ignore dir/e &&
	$VCSH foo check-ignore dir2/f &&
	$VCSH foo check-ignore dir2/g'

test_expect_success 'can be abbreviated "wri"' \
	'$VCSH wri foo &&
	test_when_finished "rm -rf .gitignore.d/"&&
	test_must_fail $VCSH foo check-ignore a &&
	test_must_fail $VCSH foo check-ignore b &&
	test_must_fail $VCSH foo check-ignore dir/d &&
	$VCSH foo check-ignore c &&
	$VCSH foo check-ignore dir/e &&
	$VCSH foo check-ignore dir2/f &&
	$VCSH foo check-ignore dir2/g'

test_expect_success 'can be abbreviated "wr"' \
	'$VCSH wr foo &&
	test_when_finished "rm -rf .gitignore.d/"&&
	test_must_fail $VCSH foo check-ignore a &&
	test_must_fail $VCSH foo check-ignore b &&
	test_must_fail $VCSH foo check-ignore dir/d &&
	$VCSH foo check-ignore c &&
	$VCSH foo check-ignore dir/e &&
	$VCSH foo check-ignore dir2/f &&
	$VCSH foo check-ignore dir2/g'

test_expect_success 'files added later ignored' \
	'$VCSH write-gitignore foo &&
	test_when_finished "rm -rf .gitignore.d/"&&
	touch x &&
	test_when_finished "rm -f x" &&
	$VCSH foo check-ignore x'

test_expect_success 'works for files with space characters' \
	'fname="$(printf '\''hello\tthere\nworld'\'')" &&
	touch "$fname" &&
	$VCSH foo add "$fname" &&
	$VCSH foo commit -m "weird chars" &&
	$VCSH write-gitignore foo &&
	test_when_finished "rm -rf .gitignore.d/"&&
	test_must_fail $VCSH foo check-ignore "$fname"'

test_expect_success 'fails if .gitignore cannot be replaced' \
	'mkdir -p .gitignore.d &&
	touch .gitignore.d/foo &&
	chmod a-w .gitignore.d .gitignore.d/foo &&
	test_when_finished "chmod u+w .gitignore.d .gitignore.d/foo" &&
	test_must_fail $VCSH write-gitignore foo'

test_done
