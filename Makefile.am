ACLOCAL_AMFLAGS = -I build-aux

.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

licensedir = $(datarootdir)/licenses/vcsh

dist_doc_DATA = README.md changelog doc/INSTALL.md doc/PACKAGING.md doc/README.md doc/error_codes.md doc/sample_hooks/post-init-add-origin doc/sample_hooks/post-init-setup-mr doc/sample_hooks/post-merge-unclobber doc/sample_hooks/pre-merge-unclobber
dist_license_DATA = LICENSE CONTRIBUTORS
dist_man_MANS = vcsh.1
bin_SCRIPTS = vcsh

EXTRA_DIST  = .version

BUILT_SOURCES = .version

vcsh.1: doc/vcsh.1.ronn
	$(RONN) < $< > $@

.version: $(shell $(AWK) '{print ".git/" $$2}' .git/HEAD 2>/dev/null ||:)
	[ -e "$@" ] && mv "$@" "$@-prev" || touch "$@-prev"
	$(if $<,./build-aux/git-version-gen .tarball-version,printf "$(VERSION)") > "$@"
	$(CMP) -s "$@" "$@-prev" || autoreconf configure.ac --force

dist-hook:
	cd $(distdir)
	echo $(VERSION) > .tarball-version
