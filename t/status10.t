#!/bin/bash

test_description='Status command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Check for socat (needed for pseudo-tty)' \
	'if which socat; then
		test_set_prereq SOCAT
	fi'

test_expect_success SOCAT 'Status colored when output to tty' \
	'$VCSH init foo &&
	touch a &&
	$VCSH run foo git add a &&
	$VCSH run foo git config --local color.status.added green &&

	# Ensure terminal is something Git will attempt to color
	TERM=vt100 &&
	export TERM &&
	printf "\\e[32mA\\e[m  a\n" >expected &&
	socat -u exec:"$VCSH status foo",pty,rawer stdio >output &&
	test_cmp expected output'

test_done
