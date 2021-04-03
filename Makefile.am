ACLOCAL_AMFLAGS = -I build-aux

.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

_vcsh = $(program_prefix)$(shell sed -e "$(program_transform_name)" <<< vcsh)$(program_suffix)

licensedir = $(datarootdir)/licenses/vcsh

dist_doc_DATA = README.md changelog doc/INSTALL.md doc/PACKAGING.md doc/README.md doc/error_codes.md doc/sample_hooks/post-init-add-origin doc/sample_hooks/post-init-setup-mr doc/sample_hooks/post-merge-unclobber doc/sample_hooks/pre-merge-unclobber
dist_license_DATA = LICENSE CONTRIBUTORS
dist_man_MANS = vcsh.1
bin_SCRIPTS = vcsh

EXTRA_DIST  = .version completions/vcsh.bash completions/vcsh.zsh

BUILT_SOURCES = .version

if ENABLE_BASH_COMPLETION
bashcompletiondir = $(BASH_COMPLETION_DIR)
nodist_bashcompletion_DATA = completions/$(_vcsh)
endif

if ENABLE_ZSH_COMPLETION
zshcompletiondir = $(ZSH_COMPLETION_DIR)
nodist_zshcompletion_DATA = completions/_$(_vcsh)
endif

vcsh.1: doc/vcsh.1.ronn
	$(RONN) < $< > $@

completions/$(_vcsh): completions/vcsh.bash
	cp -bf $< $@

completions/_$(_vcsh): completions/vcsh.zsh
	cp -bf $< $@

.version: $(shell $(AWK) '{print ".git/" $$2}' .git/HEAD 2>/dev/null ||:)
	[ -e "$@" ] && mv "$@" "$@-prev" || touch "$@-prev"
	$(if $<,./build-aux/git-version-gen .tarball-version,printf "$(VERSION)") > "$@"
	$(CMP) -s "$@" "$@-prev" || autoreconf configure.ac --force

.PHONY: test
test:
	prove

.PHONY: lint
lint:
	ec

CONTRIBUTORS:
	exec > $@
	echo 'Alphabetical list of names of everyone who ever committed to this repository.'
	echo 'Auto-generated using `make -B CONTRIBUTORS`'
	echo
	$(GIT) shortlog -se --all | cut -f1 --complement | sort -u

dist-hook:
	cd $(distdir)
	echo $(VERSION) > .tarball-version
