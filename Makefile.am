ACLOCAL_AMFLAGS = -I build-aux

.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

docdir = $(datarootdir)/doc/$(TRANSFORMED_PACKAGE_NAME)
licensedir = $(datarootdir)/licenses/$(TRANSFORMED_PACKAGE_NAME)

dist_doc_DATA = changelog doc/INSTALL.md doc/README.md doc/error_codes.md
samplehooksdir = $(docdir)/sample_hooks
dist_samplehooks_DATA = doc/sample_hooks/post-init-add-origin doc/sample_hooks/post-init-setup-mr doc/sample_hooks/post-merge-unclobber doc/sample_hooks/pre-merge-unclobber
dist_license_DATA = LICENSE CONTRIBUTORS
if ENABLE_MAN_PAGE
dist_man_MANS = vcsh.1
endif
bin_SCRIPTS = vcsh

EXTRA_DIST  = completions/vcsh.bash completions/vcsh.zsh build-aux/git-version-gen build-aux/ax_prog_perl_modules.m4

BUILT_SOURCES = .version
CLEANFILES = $(BUILT_SOURCES) .version-prev $(dist_man_MANS) $(bin_SCRIPTS)

if ENABLE_BASH_COMPLETION
bashcompletiondir = $(BASH_COMPLETION_DIR)
nodist_bashcompletion_DATA = completions/$(TRANSFORMED_PACKAGE_NAME)
CLEANFILES += $(nodist_bashcompletion_DATA)
endif

if ENABLE_ZSH_COMPLETION
zshcompletiondir = $(ZSH_COMPLETION_DIR)
nodist_zshcompletion_DATA = completions/_$(TRANSFORMED_PACKAGE_NAME)
CLEANFILES += $(nodist_zshcompletion_DATA)
endif

vcsh.1: doc/vcsh.1.ronn
	$(RONN) < $< > $@

completions/$(TRANSFORMED_PACKAGE_NAME): completions/vcsh.bash
	mkdir -p $(dir $@)
	cp -bf $< $@

completions/_$(TRANSFORMED_PACKAGE_NAME): completions/vcsh.zsh
	mkdir -p $(dir $@)
	cp -bf $< $@

.version: $(shell $(AWK) '{print ".git/" $$2}' .git/HEAD 2>/dev/null ||:)
	[ -e "$@" ] && mv "$@" "$@-prev" || $(if $<,touch,cp "$(srcdir)/.tarball-version") "$@-prev"
	$(if $<,./build-aux/git-version-gen "$(srcdir)/.tarball-version",printf "$(VERSION)") > "$@"
	$(CMP) -s "$@" "$@-prev" || autoreconf configure.ac --force

_CHECKDEPS = check-version

if ENABLE_TESTS
_CHECKDEPS += prove
endif

check-local: $(_CHECKDEPS)

installcheck-local:
	./$(TRANSFORMED_PACKAGE_NAME) version

.PHONY: check-version
check-version: vcsh | .version
	$(GREP) -Fx '$(VERSION)' $|
	./$< version | $(GREP) -Ff $|
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
lint-shellcheck: vcsh
	shellcheck $<

CONTRIBUTORS:
	exec > $@
	echo 'Alphabetical list of names of everyone who ever committed to this repository.'
	echo 'Auto-generated using `make -B CONTRIBUTORS`'
	echo
	$(GIT) shortlog -se --all | cut -f1 --complement | sort -u

changelog-HEAD: changelog
	sed -nEe '2d;s/^\t//p;/^$$/q;' $< > $@

dist-hook:
	printf "$(VERSION)" > "$(distdir)/.tarball-version"

install-exec-local:
	$(SED) -i -E '/^VCSH_SELF/s#".*"#"$(TRANSFORMED_PACKAGE_NAME)"#g' "$(DESTDIR)$(bindir)/$(TRANSFORMED_PACKAGE_NAME)"

install-data-hook:
	$(SED) -i -E 's#(\\fB)vcsh\b#\1$(TRANSFORMED_PACKAGE_NAME)#g' "$(DESTDIR)$(man1dir)/$(TRANSFORMED_PACKAGE_NAME).1"
