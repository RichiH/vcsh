.SECONDEXPANSION:

EXTRA_DIST += build-aux/git-version-gen
BUILT_SOURCES += .version
CLEANFILES += .version .version-prev

_BRANCH_REF != $(AWK) '{print ".git/" $$2}' .git/HEAD 2>/dev/null ||:
.version: $(_BRANCH_REF)
	@if [ -e "$(srcdir)/.tarball-version" ]; then \
		printf "$(VERSION)" > $@; \
	else \
		touch "$@-prev"; \
		if [ -e "$@" ]; then \
			cp "$@" "$@-prev"; \
		fi; \
		./build-aux/git-version-gen "$(srcdir)/.tarball-version" > $@; \
		$(CMP) -s "$@" "$@-prev" || autoreconf configure.ac --force; \
	fi

check-version: check-git-version

.PHONY: check-git-version
check-git-version: $(PACKAGE_NAME)$(EXEEXT) | .version
	$(GREP) -Fx '$(VERSION)' $|
	./$< --version | $(GREP) -Ff $|

installcheck-local-version:
	./$(TRANSFORMED_PACKAGE_NAME)$(EXEEXT) --version

dist-hook: dist-tarball-version

.PHONY: dist-tarball-version
dist-tarball-version:
	printf "$(VERSION)" > "$(distdir)/.tarball-version"

# vim: ft=automake
