all: test

test:
	@if ! which git   > /dev/null; then echo "'git' not found, exiting..."         ; exit 1; fi
	@if ! which prove > /dev/null; then echo "'prove' not found; not running tests"; exit 1; fi
	prove $(filter -j%,$(MAKEFLAGS)) --timer *.t
