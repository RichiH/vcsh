# Distributions with readily available packages

## Archlinux

AUR does not require any packaging information within this repository.

## Debian

Debian packages are provided by the author in separate branches, maintained in
the upstream repository

### Ubuntu

Ubuntu imports Debian's package automagically.


## Mac OS X / Homebrew

Homebrew does not require any packaging information within this repository.
A separate branch with a statically compiled manpage and release tags is
provided to ease the work of Homebrew packagers:

* The static manpage because Homebrew lacks ronn
* The tag so GitHub generates tarballs Homebrew can be pointed at


# Supporting new distributions

## Your own work

If you are maintaining a package for a different distribution, please get
in touch so your work can be included in a packaging branch in the upstream
repository.
This allows others to adapt your work for their own distributions or
packaging needs.

## Static manpage

The "debian-squeeze" branch carries a quilt patchset with a pre-compiled
manpage and the "homebrew" one carries a static manpage.

In case you can not build the manpage because you are missing ronn or you
prefer a precompiled manpage for another reason, please contact us; we will
gladly provide up-to-date packages with every release.
