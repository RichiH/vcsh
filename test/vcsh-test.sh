#!/usr/bin/env roundup

describe "test vcsh"

init() {
	export temp_dir=$(mktemp -d)
	export VCSH_BASE="$temp_dir"
	export XDG_CONFIG_HOME="$VCSH_BASE/.config"
	export VCSH='../vcsh'
	export FOO=$PWD
}

cleanup() {
	rm -rf $temp_dir
}


it_clone() {
	$VCSH clone git://github.com/RichiH/zshrc.git
	test -f $VCSH_BASE/.zshrc
}

it_correct_repo() {
	test $($VCSH list | wc -l) = 1
	test $($VCSH list) = 'zshrc'
}

it_rename_repo() {
	$VCSH rename zshrc zsh
}

it_track_changes() {
	echo foo >> $VCSH_BASE/.zshrc
	test $($VCSH run zsh git status --porcelain | wc -l) = 2
}

it_gitignore() {
	$VCSH write-gitignore zsh
	test $($VCSH run zsh git status --porcelain | wc -l) = 2
	$VCSH setup zsh
	test $($VCSH run zsh git status --porcelain | wc -l) = 1
}
