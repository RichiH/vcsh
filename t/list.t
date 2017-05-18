#!/bin/bash

test_description='List command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Setup' \
	'test_create_repo repo &&
	test_commit -C repo A &&
	test_commit -C repo B'

test_expect_success 'List command correct for no repositories' \
	'$VCSH list >output &&
	test_must_be_empty output'

test_expect_success 'List command displays inited repository' \
	'$VCSH init test1 &&
	echo test1 >expected &&
	$VCSH list >output &&
	test_cmp expected output &&
	doit | $VCSH delete test1'

test_expect_success 'List command displays cloned repository' \
	'$VCSH clone ./repo foo &&
	echo foo >expected &&
	$VCSH list >output &&
	test_cmp expected output &&
	doit | $VCSH delete foo'

test_expect_success 'List command respects $XDG_CONFIG_HOME' \
	'test_env XDG_CONFIG_HOME="$PWD/xdg1" $VCSH init test1 &&
	test_env XDG_CONFIG_HOME="$PWD/xdg2" $VCSH init test2 &&

	echo test1 >expected &&
	test_env XDG_CONFIG_HOME="$PWD/xdg1" $VCSH list >output &&
	test_cmp expected output &&

	echo test2 >expected &&
	test_env XDG_CONFIG_HOME="$PWD/xdg2" $VCSH list >output &&
	test_cmp expected output &&

	doit | test_env XDG_CONFIG_HOME="$PWD/xdg1" $VCSH delete test1 &&
	doit | test_env XDG_CONFIG_HOME="$PWD/xdg2" $VCSH delete test2'

test_expect_success 'List command respects $HOME' \
	'test_env HOME="$PWD/home1" $VCSH init test1 &&
	test_env HOME="$PWD/home2" $VCSH init test2 &&

	echo test1 >expected &&
	test_env HOME="$PWD/home1" $VCSH list >output &&
	test_cmp expected output &&

	echo test2 >expected &&
	test_env HOME="$PWD/home2" $VCSH list >output &&
	test_cmp expected output &&

	doit | test_env HOME="$PWD/home1" $VCSH delete test1 &&
	doit | test_env HOME="$PWD/home2" $VCSH delete test2'

test_expect_success 'List command prioritizes $XDG_CONFIG_HOME over $HOME' \
	'test_env HOME="$PWD/xh1" $VCSH init correct &&
	test_env HOME="$PWD/xh2" $VCSH init wrong &&

	echo correct >expected &&
	test_env HOME="$PWD/xh2" XDG_CONFIG_HOME="$PWD/xh1/.config" $VCSH list >output &&
	test_cmp expected output &&

	doit | test_env HOME="$PWD/xh1" $VCSH delete correct &&
	doit | test_env HOME="$PWD/xh2" $VCSH delete wrong'

test_expect_success 'List command prioritizes $VCSH_REPO_D over $HOME' \
	'test_env HOME="$PWD/rdh1" $VCSH init correct &&
	test_env HOME="$PWD/rdh2" $VCSH init wrong &&

	echo correct >expected &&
	test_env HOME="$PWD/rdh2" VCSH_REPO_D="$PWD/rdh1/.config/vcsh/repo.d" $VCSH list >output &&
	test_cmp expected output &&

	doit | test_env HOME="$PWD/rdh1" $VCSH delete correct &&
	doit | test_env HOME="$PWD/rdh2" $VCSH delete wrong'

test_expect_success 'List command prioritizes $VCSH_REPO_D over $XDG_CONFIG_HOME' \
	'test_env XDG_CONFIG_HOME="$PWD/xhrd1" $VCSH init correct &&
	test_env XDG_CONFIG_HOME="$PWD/xhrd2" $VCSH init wrong &&

	echo correct >expected &&
	test_env XDG_CONFIG_HOME="$PWD/xhrd2" VCSH_REPO_D="$PWD/xhrd1/vcsh/repo.d" $VCSH list >output &&
	test_cmp expected output &&

	doit | test_env XDG_CONFIG_HOME="$PWD/xhrd1" $VCSH delete correct &&
	doit | test_env XDG_CONFIG_HOME="$PWD/xhrd2" $VCSH delete wrong'

test_expect_success 'List command respects $VCSH_REPO_D' \
	'test_env VCSH_REPO_D="$PWD/rd1" $VCSH init test1 &&
	test_env VCSH_REPO_D="$PWD/rd2" $VCSH init test2 &&

	echo test1 >expected &&
	test_env VCSH_REPO_D="$PWD/rd1" $VCSH list >output &&
	test_cmp expected output &&

	echo test2 >expected &&
	test_env VCSH_REPO_D="$PWD/rd2" $VCSH list >output &&
	test_cmp expected output &&

	doit | test_env VCSH_REPO_D="$PWD/rd1" $VCSH delete test1 &&
	doit | test_env VCSH_REPO_D="$PWD/rd2" $VCSH delete test2'

test_done
