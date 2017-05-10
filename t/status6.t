#!/bin/bash

test_description='Status command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Status shows added/modified/moved/deleted files' \
	'$VCSH init foo &&

	for f in 00 0M 0D M0 MM MD A0 AM AD D0 R0x RMx RDx oo; do
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
	rm ?D &&

	echo "foo:"          >expected &&
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

test_done
