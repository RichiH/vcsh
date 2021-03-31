# BSD make-specific makefile, read only by BSD make and hence containing
# BSD make-specific extensions (e.g., "ifeq (...)", "$(shell ...)").

#FIXME: Conditionalize according to the "GNUmakefile" approach.

# Default target, running all preparatory installation targets without actually
# installing. This *MUST* be the first non-"."-prefixed target in this makefile.
all: manpages

# Install vcsh and supplementary artifacts.
install: all install-common
# Install man pages and zsh completions.
	install -m 0644 $(manpages) $(DESTDIR)$(MANDIR)/man1/
	install -m 0644 $(zshcompletions) $(DESTDIR)$(ZSH_COMPLETIONS_DIR)/

# Define all platform-agnostic variables and rules.
.include "Makefile"
