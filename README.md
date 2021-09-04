vcsh - Version Control System for $HOME - multiple Git repositories in $HOME

[![Test Status](https://github.com/RichiH/vcsh/actions/workflows/test.yml/badge.svg)](https://github.com/RichiH/vcsh/actions/workflows/test.yml)

# Index

1. [30 Second How-to](#30-second-how-to)
2. [Introduction](#introduction)
3. [Installation](#installation)
4. [Contact](#contact)


# 30 Second How-to

While it may appear that there's an overwhelming amount of documentation and
while the explanation of the concepts behind `vcsh` needs to touch a few gory
details of `git` internals, getting started with `vcsh` is extremely simple.

Let's say you want to version control your `vim` configuration:

    vcsh init vim
    vcsh vim add ~/.vimrc ~/.vim
    vcsh vim commit -m 'Initial commit of my Vim configuration'
    # optionally push your files to a remote
    vcsh vim remote add origin <remote>
    vcsh vim push -u origin master
    # from now on you can push additional commits like this
    vcsh vim push

If all that looks a _lot_ like standard `git`, that's no coincidence; it's
a design feature.


# Introduction

[vcsh][vcsh] allows you to maintain several Git repositories in one single
directory. They all maintain their working trees without clobbering each other
or interfering otherwise. By default, all Git repositories maintained via
`vcsh` store the actual files in `$HOME` but you can override this setting if
you want to.

All this means that you can have one repository per application or application
family, i.e. `zsh`, `vim`, `ssh`, etc. This, in turn, allows you to clone
custom sets of configurations onto different machines or even for different
users; picking and mixing which configurations you want to use where.
For example, you may not need to have your `mplayer` configuration on a server
or available to root and you may want to maintain different configuration for
`ssh` on your personal and your work machines.

## Talks

Some people found it useful to look at [slides](https://github.com/RichiH/talks/blob/main/2013/10-linuxcon-eu/linuxcon_eu-2013-10-gitify_your_life.pdf) and videos explaining how `vcsh`
works instead of working through the docs.
All slides, videos, and further information can be found
[on the author's talk page][talks].

# Installation

A lot of modern UNIX-based systems offer packages for `vcsh`. In case yours
does not, read [INSTALL.md](doc/INSTALL.md) for instructions on installing from
sources or even create a package for your system. If you do end up packaging
`vcsh` please let us know so we can document package availability.

# Contact

There are several ways to get in touch with the author and a small but committed
community around the general idea of version controlling your (digital) life.

* IRC: #vcs-home on irc.oftc.net

* Mailing list: [http://lists.madduck.net/listinfo/vcs-home][vcs-home-list]

* Pull requests or issues on [https://github.com/RichiH/vcsh][vcsh]


[myrepos]: http://myrepos.branchable.com/
[talks]: https://github.com/RichiH/talks
[vcsh]: https://github.com/RichiH/vcsh
[vcs-home-list]: http://lists.madduck.net/listinfo/vcs-home
