# Distro Packages

Many distributions have packages ready to go.
If yours doesn't, you can install [from source](#installing-from-source).
VCSH can also be deployed as a [standalone script](#standalone-script).
If you package VCSH for a distro please let us know.

## Arch Linux

Use your favorite AUR helper to build and install the [vcsh](https://aur.archlinux.org/packages/vcsh) package:

```console
$ paru -S aur
```

## CentOS / Fedora / RedHat

```console
$ yum install vcsh
```

## Debian / Deepin / Kali Linux / Parrot / PureOS / Raspbian / Trisquel / Ubuntu

```console
$ apt install vcsh
```

## Gentoo / Funtoo / LiGurOS

```console
$ emerge --ask dev-vcs/vcsh
```

## GNU Guix

```console
$ guix install vcsh
```

## Homebrew (macOS) / Linuxbrew

```console
$ brew install vcsh
```

## KISS Linux

```console
$ kiss install vcsh
```

## MacPorts (macOS)

```console
$ port install vcsh
```

## NIX

```console
$ nix-env -i vcsh
```

## openSUSE

```console
$ zypper install vcsh
```

## Pardus

```console
$ pisi install vcsh
```

## Termux

```console
$ pkg install vcsh
```

# Installing from Source

First you'll want a copy of the source code.
The easiest to use place to get this is the [latest release](https://github.com/RichiH/vcsh/releases/latest) posted on GitHub.
The souree distribution will have a name such as `vcsh-2.0.0.tar.xz`.
Note under each release GitHub also shows a "Source code" link that will download a snapshot of the repository; this is **not** the file you want (unless you want to jump through extra hoops).
The official source release packages are the ones you want.

Alternatively you may `git clone` the source repository.
Note than some extra tooling will be required over using the regular source releases.
Building from a clone will require a system with GNU Autotools installed; something not needed if using a source package.
Also source releases have prebuilt man pages; to (optionally) build them from a Git clone you will need `ronn`.
Finally building from Git clones will check for extra dependencies needed for testing, although tests can be disabled.
If starting from a clone, run `./bootstrap.sh` once before doing anything below.

Once you have the source, it's time to let it get aquainted with your system:

```console
$ ./configure
```

This command has *lots* of possible options, but the defaults should suite most use cases.
See `./configure --help` for details if you have special needs.

Once configured, you can build:

```console
$ make
```

Lastly you'll want to install it somewhere.

```console
$ make install
```

If you need elevated system permissions you may need to use `sudo make install` for this step.
If you don't have such permissions and wish to install to your home directory, something like this might work:

```console
$ ./configure --prefix=/
$ make DESTDIR="$HOME" install-exec
```

This will install to `~/bin/vcsh`; add `~/bin` to your path to use.

# Standalone Script

A special variant of VCSH can be deployed as a single POSIX shell script with no configure/build step.
Deploying it this way leaves you without any man page or shell completion functions (or possibly with mismatched resources installed by your package manager for a different vcsh version).
This variant is also dependent or your `$PATH` to have proper versions of dependencies such as `git`.
If your user space has different tools by default than your system beware!

The standalone variant can be downloaded from any recent entry in [releases](https://github.com/RichiH/vcsh/releases).

This method is suited for installation to a user space where you don't have control over the system packages, e.g.:

```console
$ mkdir ~/bin
$ curl -fsLS https://github.com/RichiH/vcsh/releases/latest/download/vcsh-standalone.sh -O ~/bin/vcsh
$ chmod 755 ~/bin/vcsh
```

It could also be used to directly bootstrap a dotfiles repository with something like this:

```console
$ sh <(curl -fsLS https://github.com/RichiH/vcsh/releases/latest/download/vcsh-standalone.sh) clone <path_to_your_dotfiles_repo> dotfiles
```

While we are enabling cURL-based workflows on purpose, we still encourage you to avoid them where reasonably possible. If you do use it, please consider using a tagged version that you've tested to work for you instead of the "latest" keyword.

[1]: http://rtomayko.github.io/ronn/
