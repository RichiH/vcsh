# GNU make-specific makefile, read only by GNU make and hence containing
# GNU make-specific extensions (e.g., "ifeq (...)", "$(shell ...)").

# Define all platform-agnostic variables and rules.
include Makefile

# Absolute path of zsh's completions directory. Since Debian-based Linux distros
# prefer a different directory to that of most platforms, test for the existence
# of such directory before falling back to a platform-agnostic directory.
ifneq ($(wildcard $(DESTDIR)$(ZSHDIR_PREFIX)/vendor-completions),)
ZSH_COMPLETIONS_DIR:=$(ZSHDIR_PREFIX)/vendor-completions
else ifneq ($(wildcard $(DESTDIR)$(ZSHDIR_PREFIX)/site-functions),)
ZSH_COMPLETIONS_DIR:=$(ZSHDIR_PREFIX)/site-functions
endif

# List of targets to be run both when no target is specified and when the
# "install" rule is run.
all_targets:=

# Non-empty only if the "manpages" target is listed in $(all).
is_manpaging=

# Non-empty only if the "test" target is listed in $(all).
is_testing=

# If Ronn is in the current $PATH, generate Ronn-based man pages by default.
ifneq ($(shell command -v "$(RONN)" 2>/dev/null),)
all_targets+= manpages
is_manpaging:=true
endif

# If Git, Perl, and the Perl-based unit test runner "prove" are all in the
# current $PATH and the requisite Perl modules are in the @INC module path, run
# Perl-based unit tests by default.
ifneq ($(shell command -v git 2>/dev/null),)
ifneq ($(shell command -v perl 2>/dev/null),)
ifneq ($(shell command -v prove 2>/dev/null),)
 ifeq ($(shell perl -e 'use Test::Most; use Shell::Command;' 2>&1),)
all_targets+= test
is_testing:=true
endif
endif
endif
endif

# Default target, running all preparatory installation targets without actually
# installing. This *MUST* be the first non-"."-prefixed target in this makefile.
all: $(all_targets)
# Notify the user of skipped targets.
ifeq ($(is_manpaging),)
	@echo 'Skipping man page generation: "$(RONN)" not found.' 1>&2
endif
ifeq ($(is_testing),)
	@echo 'Skipping unit tests: "git", "prove", and/or Perl modules "Test::Most" and "Shell::Command" not found.' 1>&2
endif

# Coerce the default target to be the prior target (rather than the first rule
# defined by the makefile included above).
.DEFAULT_GOAL:=all

# Install vcsh and supplementary artifacts.
install: all install-common
# If the man page has been generated, install it during installation.
ifneq ($(wildcard $(manpages)),)
	install -m 0644 $(manpages) $(DESTDIR)$(MANDIR)/man1/
endif

# If zsh's completions directory exists, install ours there during installation.
ifneq ($(ZSH_COMPLETIONS_DIR),)
	install -m 0644 $(zshcompletions) $(DESTDIR)$(ZSH_COMPLETIONS_DIR)/
endif
