#!/bin/bash

test_description='Run/enter commands'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Enter can be abbreviated (ente, ent, en)' \
	'$VCSH clone -b "$TESTBR1" "$TESTREPO" foo &&

	# sed to repeat three times
	git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1 | sed "p;p" >expected &&

	{
		echo "git rev-parse HEAD" | SHELL=/bin/sh $VCSH ente foo &&
		echo "git rev-parse HEAD" | SHELL=/bin/sh $VCSH ent foo &&
		echo "git rev-parse HEAD" | SHELL=/bin/sh $VCSH en foo
	} >output &&

	test_cmp expected output'

test_done
