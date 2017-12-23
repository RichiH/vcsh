#!/bin/sh

test_description='Delete command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_success 'Delete requires repo name' \
	'test_must_fail $VCSH delete'

test_expect_success 'Repository to be deleted must exist' \
	'test_must_fail $VCSH delete foo'

test_expect_success 'Delete requires confirmation' \
	'$VCSH init foo &&
	echo foo >expected &&

	: | test_must_fail $VCSH delete foo &&
	$VCSH list >output &&
	test_cmp expected output &&

	echo | test_must_fail $VCSH delete foo &&
	$VCSH list >output &&
	test_cmp expected output &&

	echo no | test_must_fail $VCSH delete foo &&
	$VCSH list >output &&
	test_cmp expected output &&
	
	doit | $VCSH delete foo &&
	$VCSH list >output &&
	test_must_be_empty output'

test_expect_success 'Deleted repository removed from list' \
	'$VCSH init foo &&
	$VCSH init bar &&

	doit | $VCSH delete foo &&
	echo bar >expected &&
	$VCSH list >output &&
	test_cmp expected output &&
	
	doit | $VCSH delete bar &&
	$VCSH list >output &&
	test_must_be_empty output'

test_expect_success 'Deleted repository not in status' \
	'$VCSH init foo &&
	doit | $VCSH delete foo &&

	$VCSH status >output &&
	test_line_count = 0 output'

test_expect_success 'Deleted repository cannot be subsequently used' \
	'$VCSH init foo &&
	doit | $VCSH delete foo &&

	test_must_fail $VCSH run foo echo fail'

test_expect_success 'Delete lists staged files before confirmation' \
	'vcsh_temp_repo foo &&
	touch randomtexttofind &&
	$VCSH foo add randomtexttofind &&

	: | test_must_fail $VCSH delete foo >output &&
	test_grep -F randomtexttofind <output'

# Do we actually want this?
test_expect_failure 'Delete lists files staged for removal before confirmation' \
	'vcsh_temp_repo foo &&
	touch randomtexttofind &&
	$VCSH foo add randomtexttofind &&
	$VCSH foo commit -m "a" &&
	$VCSH foo rm --cached randomtexttofind &&

	: | test_must_fail $VCSH delete foo >output &&
	test_grep -F randomtexttofind <output'

test_expect_success 'Delete removes corresponding files' \
	'$VCSH init foo &&
	$VCSH init bar &&

	touch a b c d e &&
	$VCSH foo add b e &&
	$VCSH foo commit -m "b e" &&
	$VCSH bar add a c &&
	$VCSH bar commit -m "a c" &&

	doit | $VCSH delete foo &&
	test_path_is_missing b &&
	test_path_is_missing e &&
	test_path_is_file a &&
	test_path_is_file c &&
	test_path_is_file d &&

	doit | $VCSH delete bar &&
	test_path_is_missing a &&
	test_path_is_missing c &&
	test_path_is_file d'

test_expect_failure 'Delete handles filenames with spaces properly' \
	'$VCSH init foo &&
	touch one two "one two" &&
	$VCSH foo add "one two" &&
	$VCSH foo commit -m "12" &&

	doit | $VCSH delete foo &&
	test_path_is_missing "one two" &&
	test_path_is_file one &&
	test_path_is_file two'

test_expect_failure 'Delete handles filenames with wildcard characters properly' \
	'$VCSH init foo &&
	touch a b "?" &&
	$VCSH foo add "\\?" &&
	$VCSH foo commit -m "?" &&

	doit | $VCSH delete foo &&
	test_path_is_missing "?" &&
	test_path_is_file a &&
	test_path_is_file b'

test_expect_success 'Delete can be abbreviated (delet, dele, del, de)' \
	'$VCSH init a &&
	$VCSH init b &&
	$VCSH init c &&
	$VCSH init d &&

	doit | $VCSH delet a &&
	! $VCSH list | test_grep -Fx a &&

	doit | $VCSH dele b &&
	! $VCSH list | test_grep -Fx b &&

	doit | $VCSH del c &&
	! $VCSH list | test_grep -Fx c &&

	doit | $VCSH de d &&
	! $VCSH list | test_grep -Fx d'

test_done
