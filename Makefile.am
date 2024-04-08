ACLOCAL_AMFLAGS = -I build-aux
AM_DISTCHECK_CONFIGURE_FLAGS = --enable-developer-mode

.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

docdir = $(datarootdir)/doc/$(TRANSFORMED_PACKAGE_NAME)
licensedir = $(datarootdir)/licenses/$(TRANSFORMED_PACKAGE_NAME)

bin_SCRIPTS = vcsh
dist_doc_DATA = changelog doc/INSTALL.md doc/README.md doc/error_codes.md
samplehooksdir = $(docdir)/sample_hooks
dist_samplehooks_DATA = doc/sample_hooks/post-init-add-origin doc/sample_hooks/post-init-setup-mr doc/sample_hooks/post-merge-unclobber doc/sample_hooks/pre-merge-unclobber
dist_license_DATA = LICENSE.md CONTRIBUTORS
if ENABLE_MAN_PAGE
dist_man_MANS = doc/vcsh.1
endif

EXTRA_DIST  = completions/vcsh.bash completions/vcsh.zsh build-aux/ax_prog_perl_modules.m4
EXTRA_DIST += t/000-tear-env.t t/001-setup-env.t t/100-init.t t/300-add.t t/950-delete.t t/999-tear-env.t

BUILT_SOURCES =
CLEANFILES = $(dist_man_MANS) $(bin_SCRIPTS)

# A classical use of the autoconf-archive include macro would expand
# INC_AMINCLUDE here, but the perl script that inlines include statements
# runs before the automake that organizes logic and performs substitution.
# Consequentially with a substitution here it becomes impossible to use
# automake conditionals and substitutions in the included Makefile fragments.
# By entering the expanded value directly we are ready in time for the inlining
# functionality and hence can use conditionals in included makefile fragments.
include $(top_srcdir)/aminclude.am

DISTCLEANFILES = @AMINCLUDE@

if !SOURCE_IS_DIST

doc/vcsh.1: doc/vcsh.1.ronn
	$(RONN) < $< > $@

endif

$(COMPLETIONS_OUT_DIR)/$(TRANSFORMED_PACKAGE_NAME): completions/vcsh.bash
	mkdir -p $(dir $@)
	install $< $@

$(COMPLETIONS_OUT_DIR)/_$(TRANSFORMED_PACKAGE_NAME): completions/vcsh.zsh
	mkdir -p $(dir $@)
	install $< $@

if ENABLE_TESTS
_CHECKDEPS = $(PROVE)
endif

check-local: $(_CHECKDEPS)

check-version: check-dep-versions

.PHONY: check-dep-versions
check-dep-version: $(PACKAGE_NAME) | .version
	./$< version | $(GREP) -Ff <($(GIT) version)

.PHONY: prove
prove:
	prove

.PHONY: test
test: prove

PHONY_DEVELOPER_TARGETS = lint lint-editor-config lint-shellheck
.PHONY: $(PHONY_DEVELOPER_TARGETS)

if DEVELOPER_MODE

lint: lint-editor-config lint-shellcheck

lint-editor-config:
	ec

lint-shellcheck: $(PACKAGE_NAME)
	shellcheck $<

else !DEVELOPER_MODE

$(PHONY_DEVELOPER_TARGETS):
	@: $(error "Please reconfigure using --enable-developer-mode to use developer tooling")

endif !DEVELOPER_MODE

if SOURCE_IS_GIT

CONTRIBUTORS:
	exec > $@
	echo 'Alphabetical list of names of everyone who ever committed to this repository.'
	echo 'Auto-generated using `make -B CONTRIBUTORS`'
	echo
	$(GIT) shortlog -se --all | cut -f1 --complement | sort -u

changelog-HEAD: changelog
	sed -nEe '2d;s/^\t//p;/^$$/q;' $< > $@

endif SOURCE_IS_GIT
