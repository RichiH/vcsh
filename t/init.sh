#!/bin/bash

test_description='Init command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Init command succeeds' \
	'$VCSH init foo'

test_expect_success 'Init command fails if repository already exists' \
	'test_must_fail $VCSH init foo'

test_expect_success 'Init command can be abbreviated (ini, in)' \
	'$VCSH ini bar &&
	$VCSH in baz &&
	test_must_fail $VCSH ini foo &&
	test_must_fail $VCSH in foo'

test_expect_failure 'Init command takes exactly one parameter' \
	'test_must_fail $VCSH init &&
	test_must_fail $VCSH init one two &&
	test_must_fail $VCSH init a b c'

test_expect_success 'Init creates repositories with same toplevel' \
	'toplevel="$($VCSH run foo git rev-parse --show-toplevel)" &&
	output="$($VCSH run bar git rev-parse --show-toplevel)" &&
	assert "$output" = "$toplevel"'

test_expect_success 'Init command respects alternate $VCSH_REPO_D' \
	'mkdir -p repod1 repod2 &&
	VCSH_REPO_D="$PWD/repod1" $VCSH init alt-repo &&
	VCSH_REPO_D="$PWD/repod2" $VCSH init alt-repo'

test_expect_success 'Init command respects alternate $XDG_CONFIG_HOME' \
	'mkdir -p xdg1 xdg2 &&
	XDG_CONFIG_HOME="$PWD/xdg1" $VCSH init alt-xdg &&
	XDG_CONFIG_HOME="$PWD/xdg2" $VCSH init alt-xdg'

test_expect_success 'Init command respects alternate $HOME' \
	'mkdir -p home1 home2 &&
	HOME="$PWD/home1" $VCSH init alt-home &&
	HOME="$PWD/home2" $VCSH init alt-home'

test_expect_success 'Init command fails if directories cannot be created' \
	'mkdir ro &&
	chmod a-w ro &&
	HOME="$PWD/ro" test_must_fail $VCSH init foo'

test_expect_success '$VCSH_REPO_D overrides $XDG_CONFIG_HOME and $HOME for init' \
	'mkdir -p foo4 bar4 foo4a bar4a over4a over4b &&
	HOME="$PWD/foo4" XDG_CONFIG_HOME="$PWD/bar4" VCSH_REPO_D="$PWD/over4a" $VCSH init samename &&
	HOME="$PWD/foo4a" XDG_CONFIG_HOME="$PWD/bar4" VCSH_REPO_D="$PWD/over4a" test_must_fail $VCSH init samename &&
	HOME="$PWD/foo4" XDG_CONFIG_HOME="$PWD/bar4a" VCSH_REPO_D="$PWD/over4a" test_must_fail $VCSH init samename &&
	HOME="$PWD/foo4a" XDG_CONFIG_HOME="$PWD/bar4a" VCSH_REPO_D="$PWD/over4a" test_must_fail $VCSH init samename &&
	HOME="$PWD/foo4" XDG_CONFIG_HOME="$PWD/bar4" VCSH_REPO_D="$PWD/over4b" $VCSH init samename &&
	HOME="$PWD/foo4a" XDG_CONFIG_HOME="$PWD/bar4" VCSH_REPO_D="$PWD/over4b" test_must_fail $VCSH init samename &&
	HOME="$PWD/foo4" XDG_CONFIG_HOME="$PWD/bar4a" VCSH_REPO_D="$PWD/over4b" test_must_fail $VCSH init samename &&
	HOME="$PWD/foo4a" XDG_CONFIG_HOME="$PWD/bar4a" VCSH_REPO_D="$PWD/over4b" test_must_fail $VCSH init samename'

test_expect_success '$XDG_CONFIG_HOME overrides $HOME for init' \
	'mkdir -p foo5 bar5 over5a over5b &&
	HOME="$PWD/foo5" XDG_CONFIG_HOME="$PWD/over5a" $VCSH init samename &&
	HOME="$PWD/bar5" XDG_CONFIG_HOME="$PWD/over5a" test_must_fail $VCSH init samename &&
	HOME="$PWD/foo5" XDG_CONFIG_HOME="$PWD/over5b" $VCSH init samename &&
	HOME="$PWD/bar5" XDG_CONFIG_HOME="$PWD/over5b" test_must_fail $VCSH init samename'

# Too internal to implementation?  If another command verifies
# vcsh.vcsh, use that instead of git config.
test_expect_success 'Init command marks repository with vcsh.vcsh=true' \
	'output=$($VCSH run foo git config vcsh.vcsh) &&
	assert "$output" = "true"'

test_expect_success 'Init command adds matching gitignore.d files' \
	'mkdir -p .gitattributes.d .gitignore.d &&
	touch .gitattributes.d/test1 .gitignore.d/test1 &&

	VCSH_GITIGNORE=exact $VCSH init test1 &&
	$VCSH status test1 | assert_grep -Fx "A  .gitignore.d/test1"'

test_done
