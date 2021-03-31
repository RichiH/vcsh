# make-agnostic makefile, read by all make flavours including GNU make and hence
# consisting of only POSIX make-compliant syntax.
#
# This makefile defines all variables and rules except those required by and
# including the "all" and "install" rules, whose complexity necessitates
# conditional logic inexpressible in POSIX make-compliant syntax.

self=vcsh

PREFIX?=/usr
BINDIR=$(PREFIX)/bin
DOCDIR_PREFIX=$(PREFIX)/share/doc
DOCDIR=$(DOCDIR_PREFIX)/$(self)
MANDIR=$(PREFIX)/share/man
RONN ?= ronn

# Basename of the man page to be generated.
manpages=$(self).1

# Basename of our zsh completions script.
zshcompletions=_$(self)

# Absolute path of zsh's top-level data directory.
ZSHDIR_PREFIX=$(PREFIX)/share/zsh

# Absolute path of zsh's completions directory.
ZSH_COMPLETIONS_DIR=$(ZSHDIR_PREFIX)/site-functions

# List of abstract target names not corresponding to actual paths, preventing
# conflicts with any such paths and improving efficiency in general.
.PHONY: all clean install install-common manpages moo purge test uninstall

# Install all paths *NOT* requiring conditional and hence non-POSIX logic.
install-common:
# Install the "vcsh" command.
	install -m 0755 $(self) $(DESTDIR)$(BINDIR)/

# Install documentation.
	install -d $(DESTDIR)$(DOCDIR)
	install -m 0644 README.md $(DESTDIR)$(DOCDIR)/
	install -m 0644 doc/hooks $(DESTDIR)$(DOCDIR)/

# Generate the manpage.
manpages: $(manpages)

$(self).1: doc/$(self).1.ronn
	$(RONN) < doc/$(self).1.ronn > $(self).1 || rm $(self).1

# Remove the generated manpage.
clean:
	rm -rf $(self).1

# Remove all previously installed paths.
uninstall:
	rm -rf $(DESTDIR)$(BINDIR)/$(self)
	rm -rf $(DESTDIR)$(MANDIR)/man1/$(self).1
	rm -rf $(DESTDIR)$(DOCDIR)
	rm -rf $(DESTDIR)$(ZSH_COMPLETIONS_DIR)/$(zshcompletions)

# FIXME: The "--ignore-fail-on-non-empty" option is GNU-specific.

# Remove all previously installed paths and all empty parent directories of
# these paths. Since this is potentially harmful, this target has intentionally
# been given a non-standard name. For example, if $(PREFIX) is "/usr/local" and
# now empty due to uninstalling vcsh, this target would remove "/usr/local"!
purge: uninstall
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(BINDIR)
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(MANDIR)/man1
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(DOCDIR)
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(ZSH_COMPLETIONS_DIR)

# Run all unit tests if both git and Perl's prove are found.
test:
	@if which git   > /dev/null; then :    ; else echo "'git' not found, exiting..."         ; exit 1; fi
	@if which prove > /dev/null; then prove; else echo "'prove' not found; not running tests";         fi
