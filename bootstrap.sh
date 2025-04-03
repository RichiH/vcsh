#!/usr/bin/env sh
set -e

incomplete_source () {
    printf '%s\n' \
        "$1. Please either:" \
        "* $2," \
        "* or use the source packages instead of a repo archive" \
        "* or use a full Git clone." >&2
    exit 1
}

# This enables easy building from Github's snapshot archives
if [ ! -e ".git" ]; then
    if [ ! -f ".tarball-version" ]; then
    incomplete_source "No version information found" \
        "identify the correct version with \`echo \$version > .tarball-version\`"
    fi
else
    # Just a head start to save a ./configure cycle
    ./build-aux/git-version-gen .tarball-version > .version
fi

# Autoreconf uses a perl script to inline includes from Makefile.am into
# Makefile.in before ./configure is ever run even once ... which typically means
# AX_AUTOMAKE_MACROS forfeit access to substitutions or conditional logic
# because they enter the picture after those steps. We're intentially using the
# expanded value of @INC_AMINCLUDE@ directly so the include will be inlined. To
# bootstrap we must pre-seed an empty file to avoid a 'file not found' error on
# first run. Subsequently running ./configure will generate the correct content
# based on the configuration flags and also get re-inline into Makefile.in.
touch aminclude.am

autoreconf --install
