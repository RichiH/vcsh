vcsh - Version Control System for $HOME - multiple Git repositories in $HOME


# Index

1. [30 second howto](#30-second-howto)
2. [Introduction](#introduction)
3. [Usage Exmaples](#usage-examples)
4. [Overview](#overview)
5. [Getting Started](#getting-started)
6. [Contact](#contact)


# 30 second howto

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

A lot of modern UNIX-based systems offer packages for `vcsh`. In case yours
does not read `INSTALL.md` for install instructions or `PACKAGING.md` to create
a package, yourself. If you do end up packaging `vcsh` please let us know so we
can give you your own packaging branch in the upstream repository.

## Talks

Some people found it useful to look at slides and videos explaining how `vcsh`
works instead of working through the docs.
All slides, videos, and further information can be found
[on the author's talk page][talks].


# Usage Examples

There are three different ways to interact with `vcsh` repositories; this
section will only show the simplest and easiest way.
Certain more advanced use cases require the other two ways, but don't worry
about this for now. If you never even bother playing with the other two
modes you will still be fine.
`vcsh enter` and `vcsh run`  will be covered in later sections.


| Task                                                  | Command                                           |
| ----------------------------------------------------- | ------------------------------------------------- |
| _Initialize a new repository called "vim"_            |   `vcsh init vim`                                 |
| _Clone an existing repository_                        |   `vcsh clone <remote> <repository_name>`         |
| _Add files to repository "vim"_                       |   `vcsh vim add ~/.vimrc ~/.vim`                  |
|                                                       |   `vcsh vim commit -m 'Update Vim configuration'` |
| _Add a remote for repository "vim"_                   |   `vcsh vim remote add origin <remote>`           |
|                                                       |   `vcsh vim push origin master:master`            |
|                                                       |   `vcsh vim branch --track master origin/master`  |
| _Push to remote of repository "vim"_                  |   `vcsh vim push`                                 |
| _Pull from remote of repository "vim"_                |   `vcsh vim pull`                                 |
| _Show status of changed files in all repositories_    |   `vcsh status`                                   |
| _Pull from all repositories_                          |   `vcsh pull`                                     |
| _Push to all repositories_                            |   `vcsh push`                                     |


# Overview

## From zero to vcsh

You put a lot of effort into your configuration and want to both protect and
distribute this configuration.

Most people who decide to put their dotfiles under version control start with a
single repository in `$HOME`, adding all their dotfiles (and possibly more)
to it. This works, of course, but can become a nuisance as soon as you try to
manage more than one host.

The next logical step is to create single-purpose repositories in, for example,
`~/.dotfiles` and to create symbolic links into `$HOME`. This gives you the
flexibility to check out only certain repositories on different hosts. The
downsides of this approach are the necessary manual steps of cloning and
symlinking the individual repositories.

`vcsh` takes this approach one step further. It enables single-purpose
repositories and stores them in a hidden directory. However, it does not create
symbolic links in `$HOME`; it puts the actual files right into `$HOME`.

As `vcsh` allows you to put an arbitrary number of distinct repositories into
your `$HOME`, you will end up with a lot of repositories very quickly.

To manage both `vcsh` and other repositories, we suggest using [mr](mr). `mr`
takes care of pulling in and pushing out new data for a variety of version
control systems.

`vcsh` was designed with [mr][mr], a tool to manage Multiple Repositories, in
mind and the two integrate very nicely. `mr` has native support for `vcsh`
repositories and to `vcsh`, `mr` is just another configuration to track.
This make setting up any new machine a breeze. It takes literally less than
five minutes to go from standard installation to fully set up system

This is where `mr` comes in. While the use of `mr` is technically
optional, but it will be an integral part of the proposed system that follows.

## Default Directory Layout

To illustrate, this is what a possible directory structure looks like.

    $HOME
        |-- $XDG_CONFIG_HOME (defaults to $HOME/.config)
        |   |-- mr
        |   |   |-- available.d
        |   |   |   |-- zsh.vcsh
        |   |   |   |-- gitconfigs.vcsh
        |   |   |   |-- lftp.vcsh
        |   |   |   |-- offlineimap.vcsh
        |   |   |   |-- s3cmd.vcsh
        |   |   |   |-- tmux.vcsh
        |   |   |   |-- vim.vcsh
        |   |   |   |-- vimperator.vcsh
        |   |   |   `-- snippets.git
        |   |   `-- config.d
        |   |       |-- zsh.vcsh        -> ../available.d/zsh.vcsh
        |   |       |-- gitconfigs.vcsh -> ../available.d/gitconfigs.vcsh
        |   |       |-- tmux.vcsh       -> ../available.d/tmux.vcsh
        |   |       `-- vim.vcsh        -> ../available.d/vim.vcsh
        |   `-- vcsh
        |       |-- config
        |       `-- repo.d
        |           |-- zsh.git  -----------+
        |           |-- gitconfigs.git      |
        |           |-- tmux.git            |
        |           `-- vim.git             |
        |-- [...]                           |
        |-- .zshrc   <----------------------+
        |-- .gitignore.d
        |   `-- zsh
        |-- .mrconfig
        `-- .mrtrust

### available.d

The files you see in $XDG\_CONFIG\_HOME/mr/available.d are mr configuration files
that contain the commands to manage (checkout, update etc.) a single
repository. vcsh repo configs end in .vcsh, git configs end in .git, etc. This
is optional and your preference. For example, this is what a zsh.vcsh
with read-only access to my zshrc repo looks likes. I.e. in this specific
example, push can not work as you will be using the author's repository. This
is for demonstration, only. Of course, you are more than welcome to clone from
this repository and fork your own.

    [$XDG_CONFIG_HOME/vcsh/repo.d/zsh.git]
    checkout = vcsh clone 'git://github.com/RichiH/zshrc.git' zsh
    update   = vcsh zsh pull
    push     = vcsh zsh push
    status   = vcsh zsh status
    gc       = vcsh zsh gc

### config.d

$XDG\_CONFIG\_HOME/mr/available.d contains *all available* repositories. Only
files/links present in mr/config.d, however, will be used by mr. That means
that in this example, only the zsh, gitconfigs, tmux and vim repositories will
be checked out. A simple `mr update` run in $HOME will clone or update those
four repositories listed in config.d.

### ~/.mrconfig

Finally, ~/.mrconfig will tie together all those single files which will allow
you to conveniently run `mr up` etc. to manage all repositories. It looks like
this:

    [DEFAULT]
    include = cat ${XDG_CONFIG_HOME:-$HOME/.config}/mr/config.d/*

### repo.d

$XDG\_CONFIG\_HOME/vcsh/repo.d is the directory where all git repositories which
are under vcsh's control are located. Since their working trees are configured
to be in $HOME, the files contained in those repositories will be put in $HOME
directly.
Of course, [mr] [mr] will work with this layout if configured according to this
document (see above).

vcsh will check if any file it would want to create exists. If it exists, vcsh
will throw a warning and exit. Move away your old config and try again.
Optionally, merge your local and your global configs afterwards and push with
`vcsh foo push`.

## Moving into a New Host

To illustrate further, the following steps could move your desired
configuration to a new host.

1. Clone the mr repository (containing available.d, config.d etc.); for
   example: `vcsh clone git://github.com/RichiH/vcsh_mr_template.git mr`
2. Choose your repositories by linking them in config.d (or go with the default
   you may have already configured by adding symlinks to git).
3. Run mr to clone the repositories: `cd; mr update`.
4. Done.

Hopefully the above could help explain how this approach saves time by

1. making it easy to manage, clone and update a large number of repositories
   (thanks to mr) and
2. making it unnecessary to create symbolic links in $HOME (thanks to vcsh).

If you want to give vcsh a try, follow the instructions below.


# Getting Started

Below, you will find a few different methods for setting up vcsh:

1. The Template Way
2. The Steal-from-Template Way
3. The Manual Way

### The Template Way

#### Prerequisites

Make sure none of the following files and directories exist for your test
(user). If they do, move them away for now:

* ~/.gitignore.d
* ~/.mrconfig
* $XDG\_CONFIG\_HOME/mr/available.d/mr.vcsh
* $XDG\_CONFIG\_HOME/mr/available.d/zsh.vcsh
* $XDG\_CONFIG\_HOME/mr/config.d/mr.vcsh
* $XDG\_CONFIG\_HOME/vcsh/repo.d/mr.git/

All of the files are part of the template repository, the directory is where
the template will be stored.

    apt-get install mr

#### Install vcsh

#### Debian

If you are using Debian Squeeze, you will need to enable backports

    apt-get install vcsh

#### Arch Linux

vcsh is availabe via [AUR](https://aur.archlinux.org/packages.php?ID=54164)
and further documentation about the use of AUR is available
[on Arch's wiki](https://wiki.archlinux.org/index.php/Arch_User_Repository).

    cd /var/abs/local/
    wget https://aur.archlinux.org/packages/vc/vcsh-git/vcsh-git.tar.gz
    tar xfz vcsh-git.tar.gz
    cd vcsh-git
    makepkg -s
    pacman -U vcsh*.pkg.tar.xz

#### From source

    # choose a location for your checkout
    mkdir -p ~/work/git
    cd ~/work/git
    git clone git://github.com/RichiH/vcsh.git
    cd vcsh
    sudo ln -s vcsh /usr/local/bin                       # or add it to your PATH
    cd

#### Clone the Template

    vcsh clone git://github.com/RichiH/vcsh_mr_template.git mr

#### Enable Your Test Repository

    mv ~/.zsh   ~/zsh.bak
    mv ~/.zshrc ~/zshrc.bak
    cd $XDG_CONFIG_HOME/mr/config.d/
    ln -s ../available.d/zsh.vcsh .  # link, and thereby enable, the zsh repository
    cd
    mr up

#### Set Up Your Own Repositories

Now, it's time to edit the template config and fill it with your own remotes:

    vim $XDG_CONFIG_HOME/mr/available.d/mr.vcsh
    vim $XDG_CONFIG_HOME/mr/available.d/zsh.vcsh

And then create your own stuff:

    vcsh init foo
    vcsh foo add bar baz quux
    vcsh foo remote add origin git://quuux
    vcsh foo commit
    vcsh foo push

    cp $XDG_CONFIG_HOME/mr/available.d/mr.vcsh $XDG_CONFIG_HOME/mr/available.d/foo.vcsh
    vim $XDG_CONFIG_HOME/mr/available.d/foo.vcsh # add your own repo

Done!

### The Steal-from-Template Way

You're welcome to clone the example repository:

    vcsh clone git://github.com/RichiH/vcsh_mr_template.git mr
    # make sure 'include = cat /usr/share/mr/vcsh' points to an exiting file
    vim .mrconfig

Look around in the clone. It should be reasonably simple to understand. If not,
poke me, RichiH, on Freenode (query) or OFTC (#vcs-home).


### The Manual Way

This is how my old setup procedure looked like. Adapt it to your own style or
copy mine verbatim, either is fine.

    # Create workspace
    mkdir -p ~/work/git
    cd !$

    # Clone vcsh and make it available
    git clone git://github.com/RichiH/vcsh.git vcsh
    sudo ln -s ~/work/git/vcsh/vcsh /usr/bin/local
    hash -r

Grab my mr config. see below for details on how I set this up

    vcsh clone ssh://<remote>/mr.git
    cd $XDG_CONFIG_HOME/mr/config.d/
    ln -s ../available.d/* .


mr is used to actually retrieve configs, etc

    ~ % cat ~/.mrconfig
    [DEFAULT]
    # adapt /usr/share/mr/vcsh to your system if needed
    include = cat /usr/share/mr/vcsh
    include = cat $XDG_CONFIG_HOME/mr/config.d/*
    ~ % echo $XDG_CONFIG_HOME
    /home/richih/.config
    ~ % ls $XDG_CONFIG_HOME/mr/available.d # random selection of my repos
    git-annex gitk.vcsh git.vcsh ikiwiki mr.vcsh reportbug.vcsh snippets.git wget.vcsh zsh.vcsh
    ~ %
    # then simply ln -s whatever you want on your local machine from
    # $XDG_CONFIG_HOME/mr/available.d to $XDG_CONFIG_HOME/mr/config.d
    ~ % cd
    ~ % mr -j 5 up


# mr usage ; will be factored out & rewritten

### Keeping repositories Up-to-Date

This is the beauty of it all. Once you are set up, just run:

    mr up
    mr push

Neat.

### Making Changes

After you have made some changes, for which you would normally use `git add`
and `git commit`, use the vcsh wrapper (like above):

    vcsh foo add bar baz quux
    vcsh foo commit
    vcsh foo push

### Using vcsh without mr

vcsh encourages you to use [mr][mr]. It helps you manage a large number of
repositories by running the necessary vcsh commands for you. You may choose not
to use mr, in which case you will have to run those commands manually or by
other means.


To initialize a new repository: `vcsh init zsh`

To clone a repository: `vcsh clone ssh://<remote>/zsh.git`

To interact with a repository, use the regular Git commands, but prepend them
with `vcsh run $repository_name`. For example:

    vcsh zsh status
    vcsh zsh add .zshrc
    vcsh zsh commit

Obviously, without mr keeping repositories up-to-date, it will have to be done
manually. Alternatively, you could try something like this:

    for repo in `vcsh list`; do
        vcsh run $repo git pull;
    done


# Contact

There are several ways to get in touch with the author and a small but committed
community around the general idea of version controlling your (digital) life.

* IRC: #vcs-home on irc.oftc.net

* Mailing list: [http://lists.madduck.net/listinfo/vcs-home][vcs-home-list]

* Pull requests or issues on [https://github.com/RichiH/vcsh][vcsh]


[mr]: http://kitenet.net/~joey/code/mr/
[talks]: http://richardhartmann.de/talks/
[vcsh]: https://github.com/RichiH/vcsh
[vcs-home-list]: http://lists.madduck.net/listinfo/vcs-home
