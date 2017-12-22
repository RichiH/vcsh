#!/bin/bash

test_description='Status command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.sh"

test_expect_success 'Status argument if any must be a repo' \
	'test_must_fail $VCSH status nope'

test_expect_success 'Status command correct for no repos' \
	'$VCSH status >output &&
	test_must_be_empty output'

test_setup 'Create empty repo' \
	'$VCSH init foo'

test_expect_success 'Status command correct for empty repo' \
	'echo "foo:"  >expected &&
	echo ""     >>expected &&
	$VCSH status >output &&
	test_cmp expected output'

test_expect_success 'Terse status correct for empty repo' \
	'$VCSH status --terse >output &&
	test_must_be_empty output'

test_setup 'Check for socat (needed for pseudo-tty)' \
	'if which socat; then
		test_set_prereq SOCAT
	fi'

test_setup 'Set color config' \
	'$VCSH run foo git config --local color.status.added green'

test_setup 'Create and add a file' \
	'touch a &&
	$VCSH run foo git add a'

test_expect_success SOCAT 'Status colored when output to tty' \
	'# Ensure terminal is something Git will attempt to color
	TERM=vt100 &&
	export TERM &&
	printf "\\e[m\n" >expected &&
	socat -u exec:"$VCSH status foo",pty,rawer stdio >output &&
	test_grep -Ff expected output'

test_setup 'Delete repository, init foo and bar' \
	'doit | $VCSH delete foo &&
	$VCSH init foo &&
	$VCSH init bar'

test_expect_success 'Status command correct for multiple empty repos' \
	'echo "bar:"  >expected &&
	echo ""     >>expected &&
	echo "foo:" >>expected &&
	echo ""     >>expected &&
	$VCSH status >output &&
	test_cmp expected output'

test_expect_success 'Terse status correct for multiple empty repos' \
	'$VCSH status --terse >output &&
	test_must_be_empty output'

test_setup 'Set up files with many statuses' \
	'for f in 00 0M 0D M0 MM MD A0 AM AD D0 R0x RMx RDx oo; do
		echo "$f" > "$f"
	done &&
	$VCSH foo add 00 0M 0D M0 MM MD D0 R0x RMx RDx &&
	$VCSH foo commit -m "commit" &&

	# Modified in index
	for f in M?; do
		echo changed > $f
	done &&
	$VCSH foo add M? &&

	# Added to index
	$VCSH foo add A? &&

	# Deleted in index
	$VCSH foo rm -q --cached D? &&

	# Renamed in index
	for f in R?x; do
		$VCSH foo mv "$f" "${f%x}"
	done &&

	# Modified locally
	for f in ?M; do
		echo localchanged > $f
	done &&

	# Deleted locally
	rm ?D'

test_expect_success 'Status shows added/modified/moved/deleted files' \
	'echo "bar:"          >expected &&
	echo ""             >>expected &&
	echo "foo:"         >>expected &&
	echo " D 0D"        >>expected &&
	echo " M 0M"        >>expected &&
	echo "A  A0"        >>expected &&
	echo "AD AD"        >>expected &&
	echo "AM AM"        >>expected &&
	echo "D  D0"        >>expected &&
	echo "M  M0"        >>expected &&
	echo "MD MD"        >>expected &&
	echo "MM MM"        >>expected &&
	echo "R  R0x -> R0" >>expected &&
	echo "RD RDx -> RD" >>expected &&
	echo "RM RMx -> RM" >>expected &&
	echo ""             >>expected &&
	$VCSH status >output &&
	test_cmp expected output'

test_expect_success 'Status can be abbreviated (statu, stat, sta, st)' \
	'$VCSH status >expected &&

	for cmd in statu stat sta st; do
		$VCSH $cmd >output &&
		test_cmp expected output
	done'

#test_expect_success 'Status shows commits behind upstream'
#test_expect_success 'Status shows commits ahead of upstream'
#test_expect_success 'Status shows commits behind and ahead of upstream'

test_done
