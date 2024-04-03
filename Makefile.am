ACLOCAL_AMFLAGS = -I build-aux

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

include $(top_srcdir)/build-aux/git_version.mk
include $(top_srcdir)/build-aux/dist_checksums.mk
include $(top_srcdir)/build-aux/shell_completion_dirs.mk

if !IS_SDIST
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
_CHECKDEPS = prove
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

.PHONY: lint
lint: lint-editor-config lint-shellcheck

.PHONY: lint-editor-config
lint-editor-config:
	ec

.PHONY: lint-shellheck
lint-shellcheck: $(PACKAGE_NAME)
	shellcheck $<

CONTRIBUTORS:
	exec > $@
	echo 'Alphabetical list of names of everyone who ever committed to this repository.'
	echo 'Auto-generated using `make -B CONTRIBUTORS`'
	echo
	$(GIT) shortlog -se --all | cut -f1 --complement | sort -u

changelog-HEAD: changelog
	sed -nEe '2d;s/^\t//p;/^$$/q;' $< > $@
