#!/bin/sh

test_description='Commit command'

. ./sharness/sharness.sh
. "$SHARNESS_TEST_DIRECTORY/environment.sh"

test_expect_success 'commit works with no repos' \
	'$VCSH commit >output &&
	test_must_be_empty output'

test_expect_success 'commit works with single repo' \
	'vcsh_temp_repo one &&
	touch single &&
	$VCSH one add single &&
	# XXX Is printing a trailing space really intended?
	echo "one: " >expected &&
	echo ""     >>expected &&
	$VCSH commit -m "single" >output &&
	test_cmp expected output &&

	echo 1 >expected &&
	$VCSH one rev-list HEAD --count >output &&
	test_cmp expected output'

test_expect_success 'commit can be abbreviated (commi, comm, com, co)' \
	'vcsh_temp_repo abbr &&
	touch commi &&
	$VCSH abbr add commi &&
	$VCSH commi -m "commi" &&
	touch comm &&
	$VCSH abbr add comm &&
	$VCSH comm -m "comm" &&
	touch com &&
	$VCSH abbr add com &&
	$VCSH com -m "com" &&
	touch co &&
	$VCSH abbr add co &&
	$VCSH co -m "co" &&

	echo 4 >expected &&
	$VCSH abbr rev-list --count HEAD >output &&
	test_cmp expected output'

test_setup 'create two repositories' \
	'$VCSH init foo &&
	$VCSH init bar'

test_expect_success 'commit works with multiple repos' \
	'touch multi1 multi2 &&
	$VCSH foo add multi1 &&
	$VCSH bar add multi2 &&
	# XXX Is printing a trailing space and blank line really intended?
	echo "bar: "  >expected &&
	echo ""      >>expected &&
	echo "foo: " >>expected &&
	echo ""      >>expected &&
	$VCSH commit -m "multiple" >output &&
	test_cmp expected output &&

	$VCSH foo log --oneline | test_grep -x "....... multiple" &&
	$VCSH bar log --oneline | test_grep -x "....... multiple"'

test_expect_success 'commit can handle arguments with spaces' \
	'touch msg1 msg2 &&
	$VCSH foo add msg1 &&
	$VCSH bar add msg2 &&
	$VCSH commit -m "log message" &&

	$VCSH foo log --oneline | test_grep -x "....... log message" &&
	$VCSH bar log --oneline | test_grep -x "....... log message"'

# Commit returns failure if last repository has no staged changes
test_expect_success 'commit works even if not all repos have changes' \
	'touch part1 part2 &&
	$VCSH foo add part1 &&
	$VCSH commit -m "part1" &&

	$VCSH bar add part2 &&
	$VCSH commit -m "part2" &&

	$VCSH foo log --oneline | test_grep -x "....... part1" &&
	$VCSH bar log --oneline | test_grep -x "....... part2"'

# Known bug
test_expect_success 'commit not affected by existing $VCSH_COMMAND_RETURN_CODE' \
	'VCSH_COMMAND_RETURN_CODE=1 &&
	export VCSH_COMMAND_RETURN_CODE &&
	$VCSH commit'

test_done
