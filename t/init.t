#!/bin/bash

test_description='Init command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Init command succeeds' \
	'$VCSH init foo'

test_expect_success 'Init command creates new Git repository' \
	'find_gitrepos "$PWD" >output &&
	test_line_count = 1 output &&

	for i in $(test_seq 2 5); do
		$VCSH init "count$i" &&
		find_gitrepos "$PWD" >output &&
		test_line_count = "$i" output
	done'

# verifies commit e220a61
test_expect_success 'Files created by init are not readable by other users' \
	'find "$HOME" -type f -perm /g+rwx,o+rwx ! -path "$HOME/output" >output &&
	test_must_be_empty output'

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
	'$VCSH run foo git rev-parse --show-toplevel >output1 &&
	$VCSH run bar git rev-parse --show-toplevel >output2 &&
	test_cmp output1 output2'

test_expect_success 'Init command respects alternate $VCSH_REPO_D' \
	'mkdir -p repod1 repod2 &&
	test_env VCSH_REPO_D="$PWD/repod1" $VCSH init alt-repo &&
	test_env VCSH_REPO_D="$PWD/repod2" $VCSH init alt-repo'

test_expect_success 'Init command respects alternate $XDG_CONFIG_HOME' \
	'mkdir -p xdg1 xdg2 &&
	test_env XDG_CONFIG_HOME="$PWD/xdg1" $VCSH init alt-xdg &&
	test_env XDG_CONFIG_HOME="$PWD/xdg2" $VCSH init alt-xdg'

test_expect_success 'Init command respects alternate $HOME' \
	'mkdir -p home1 home2 &&
	test_env HOME="$PWD/home1" $VCSH init alt-home &&
	test_env HOME="$PWD/home2" $VCSH init alt-home'

test_expect_success 'Init command fails if directories cannot be created' \
	'mkdir ro &&
	chmod a-w ro &&
	test_env HOME="$PWD/ro" test_must_fail $VCSH init readonly'

test_expect_success '$VCSH_REPO_D overrides $XDG_CONFIG_HOME and $HOME for init' \
	'mkdir -p foo4 bar4 foo4a bar4a over4a over4b &&
	test_env HOME="$PWD/foo4" XDG_CONFIG_HOME="$PWD/bar4" VCSH_REPO_D="$PWD/over4a" $VCSH init samename1 &&
	test_env HOME="$PWD/foo4a" XDG_CONFIG_HOME="$PWD/bar4" VCSH_REPO_D="$PWD/over4a" test_must_fail $VCSH init samename1 &&
	test_env HOME="$PWD/foo4" XDG_CONFIG_HOME="$PWD/bar4a" VCSH_REPO_D="$PWD/over4a" test_must_fail $VCSH init samename1 &&
	test_env HOME="$PWD/foo4a" XDG_CONFIG_HOME="$PWD/bar4a" VCSH_REPO_D="$PWD/over4a" test_must_fail $VCSH init samename1 &&
	test_env HOME="$PWD/foo4" XDG_CONFIG_HOME="$PWD/bar4" VCSH_REPO_D="$PWD/over4b" $VCSH init samename1 &&
	test_env HOME="$PWD/foo4a" XDG_CONFIG_HOME="$PWD/bar4" VCSH_REPO_D="$PWD/over4b" test_must_fail $VCSH init samename1 &&
	test_env HOME="$PWD/foo4" XDG_CONFIG_HOME="$PWD/bar4a" VCSH_REPO_D="$PWD/over4b" test_must_fail $VCSH init samename1 &&
	test_env HOME="$PWD/foo4a" XDG_CONFIG_HOME="$PWD/bar4a" VCSH_REPO_D="$PWD/over4b" test_must_fail $VCSH init samename1'

test_expect_success '$XDG_CONFIG_HOME overrides $HOME for init' \
	'mkdir -p foo5 bar5 over5a over5b &&
	test_env HOME="$PWD/foo5" XDG_CONFIG_HOME="$PWD/over5a" $VCSH init samename2 &&
	test_env HOME="$PWD/bar5" XDG_CONFIG_HOME="$PWD/over5a" test_must_fail $VCSH init samename2 &&
	test_env HOME="$PWD/foo5" XDG_CONFIG_HOME="$PWD/over5b" $VCSH init samename2 &&
	test_env HOME="$PWD/bar5" XDG_CONFIG_HOME="$PWD/over5b" test_must_fail $VCSH init samename2'

# Too internal to implementation?  If another command verifies
# vcsh.vcsh, use that instead of git config.
test_expect_success 'Init command marks repository with vcsh.vcsh=true' \
	'echo true >expected &&
	$VCSH run foo git config vcsh.vcsh >output &&
	test_cmp expected output'

test_expect_success 'Init command adds matching gitignore.d files' \
	'mkdir -p .gitattributes.d .gitignore.d &&
	touch .gitattributes.d/ignore-d .gitignore.d/ignore-d &&

	test_env VCSH_GITIGNORE=exact $VCSH init ignore-d &&
	$VCSH status ignore-d | assert_grep -Fx "A  .gitignore.d/ignore-d"'

test_expect_success 'VCSH_GITIGNORE variable is validated' \
	'test_env VCSH_GITIGNORE=x test_must_fail $VCSH init ignore1 &&
	test_env VCSH_GITIGNORE=nonsense test_must_fail $VCSH init ignore2 &&
	test_env VCSH_GITIGNORE=fhqwhgads test_must_fail $VCSH init ignore3'

# XXX test instead by making sure files are actually excluded, not by
# reading config option
test_expect_success 'Init command sets core.excludesfile with VCSH_GITIGNORE=exact' \
	'test_env VCSH_GITIGNORE=exact $VCSH init excludes &&
	$VCSH run excludes git config core.excludesfile'

# XXX test instead by making sure files are actually excluded, not by
# reading config option
test_expect_success 'Init command sets core.excludesfile with VCSH_GITIGNORE=recursive' \
	'test_env VCSH_GITIGNORE=recursive $VCSH init excludes-r &&
	$VCSH run excludes-r git config core.excludesfile'

test_expect_success 'Init command does not set core.excludesfile with VCSH_GITIGNORE=none' \
	'test_env VCSH_GITIGNORE=none $VCSH init excludes-n &&
	test_must_fail $VCSH run excludes-n git config core.excludesfile'

test_expect_success 'Init command sets core.attributesfile with VCSH_GITATTRIBUTES!=none' \
	'test_env VCSH_GITATTRIBUTES=whatever $VCSH init attrs &&
	$VCSH run attrs git config core.attributesfile'

test_expect_success 'Init command does not set core.attributesfile with VCSH_GITATTRIBUTES=none' \
	'test_env VCSH_GITATTRIBUTES=none $VCSH init no-attrs &&
	test_must_fail $VCSH run no-attrs git config core.attributesfile'

test_done
