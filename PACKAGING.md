# Archlinux

AUR does not require any packaging information within this repository.

# Debian

Debian packages are provided by the author in separate branches, maintained in
the upstream repository

## Ubuntu

Ubuntu imports Debian's package automagically.


# Mac OS X

Homebrew does not require any packaging information within this repository.
A separate branch with a statically compiled manpage and release tags is
provided to ease packaging. The static manpage because Homebrew lacks ronn;
the tag so github generates tarballs Homebrew can be pointed at.


# Additional notes

## Static manpage

In case you can not build the manpage because you are missing ronn please
contact the author. The "debian-squeeze" branch carries a quilt patchset with
a pre-compiled manpage and the "homebrew" one carries a static manpage. If you
need, or want, to build your packages against a static version in your own
branch this can be done.

## Other systems

If you are maintaining a package for a different distribution, please get
in touch so your work can be included in another branch, thus allowing others
to adapt it to their needs or to improve upon it.
