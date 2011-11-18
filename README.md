vcsh - manage and sync config files via git

# Index #

1. Introduction
2. Overview
3. Getting Started
4. Usage

# 1 Introduction #

vcsh allows you to have several git repositories, all maintaining their working
trees in $HOME without clobbering each other. That, in turn, means you can have
one repository per config set (zsh, vim, ssh, etc), picking and choosing which
configs you want to use on which machine.

vcsh was designed with [mr] [1] in mind so you might want to install that, as
well.

Read INSTALL.md for detailed setup instructions.

The following overview will try to give you an idea of the use cases and
advantages of vcsh. See sections 3 and 4 for detailed instructions and
examples.

# 2 Overview

## 2.1 Comparison to Other Solutions ##

Most people who decide to put their dotfiles under version control start with a
**single repository in $HOME**, adding all their dotfiles (and possibly more)
to it. This works, of course, but can become a nuisance as soon as you try to
manage more than one host.

The next logical step is to create single-purpose repositories in, for example,
~/.dotfiles and to create **symbolic links in $HOME**. This gives you the
flexibility to check out only certain repositories on different hosts. The
downsides of this approach are the necessary manual steps of cloning and
symlinking the individual repositories. It will probably become a nuisance when
you try to manage more than two hosts.

**vcsh** takes this second approach one step further. It expects
**single-purpose repositories** and stores them in a hidden directory (similar
to ~/.dotfiles). However, it does not create symbolic links in $HOME; it puts
the **actual files right into $HOME**.

Furthermore, by making use of [mr] [1], it makes it very easy to enable/disable
and clone a large number of repositories. The use of mr is technically optional
(see 3.4), but it will be an integral part of the proposed system that follows.

## 2.2 Default Directory Layout ##

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
        |       `-- repo.d
        |           |-- zsh.git  -----------+
        |           |-- gitconfigs.git      |
        |           |-- tmux.git            |
        |           `-- vim.git             |
        |-- [...]                           |
        |-- .zshrc   <----------------------+
        |-- .gitignore
        |-- .mrconfig
        `-- .mrtrust

### available.d ###

The files you see in $XDG_CONFIG_HOME/mr/available.d are mr configuration files that
contain the commands to manage (checkout, update etc.) a single repository.
vcsh repo configs end in .vcsh, git configs end in .git, etc. This is optional
and your preference. For example, this is what a zsh.mrconfig with read-only
access to my zshrc repo looks likes. I.e. in this specific example, push can
not work.

    [$XDG_CONFIG_HOME/vcsh/repo.d/zsh.git]
    checkout = vcsh clone 'git://github.com/RichiH/zshrc.git' zsh
    update   = vcsh run zsh git pull
    push     = vcsh run zsh git push
    status   = vcsh run zsh git status
    gc       = vcsh run zsh git gc

### config.d ###

$XDG_CONFIG_HOME/mr/available.d contains *all available* repositories. Only
files/links present in mr/config.d, however, will be used by mr. That means
that in this example, only the zsh, gitconfigs, tmux and vim repositories will
be checked out. A simple `mr update` run in $HOME will clone or update those
four repositories listed in config.d.

### ~/.mrconfig ###

Finally, ~/.mrconfig will tie together all those single files which will allow
you to conveniently run `mr up` etc. to manage all repositories. It looks like
this:

    [DEFAULT]
    jobs = 5
    include = cat $XDG_CONFIG_HOME/mr/config.d/*

### repo.d ###

$XDG_CONFIG_HOME/vcsh/repo.d is the directory into which vcsh clones the git
repositories. Since their working trees are configured to be in $HOME, the
files contained in those repositories will be put in $HOME directly (see .zshrc
above).


vcsh will check if any file it would want to create exists. If it exists, vcsh
will throw a warning and exit. Move away your old config and try again.
Optionally, merge your local and your global configs afterwards and push with
`vcsh run foo git push`.

## 2.3 Moving into a New Host ##

To illustrate further, the following steps could move your desired
configuration to a new host.

1. Clone the mr repository (containing available.d, config.d etc.); for
   example: `vcsh clone git://github.com/RichiH/vcsh_mr_template.git`
2. Choose your repositories by linking them in config.d (or go with the default
   you may have already configured by adding symlinks to git).
3. Run mr to clone the repositories: `cd; mr update`.
4. Done.

Hopefully the above could help explain how this approach saves time by

1. making it easy to manage, clone and update a large number of repositories
   (thanks to mr) and
2. making it unnecessary to create symbolic links in $HOME (thanks to vcsh).

If you want to give vcsh a try, follow the instructions below.

# 3 Getting Started #

Below, you will find a few different methods for setting up vcsh:

3.1. The Template Way
3.2. The Steal-from-Template Way
3.3. The Manual Way

### 3.1 The Template Way ###

#### 3.1.1 Prerequisites ####

Make sure none of the following files and directories exist for your test
(user). If they do, move them away for now:

* ~/.gitignore
* ~/.mrconfig
* $XDG_CONFIG_HOME/mr/available.d/mr.vcsh
* $XDG_CONFIG_HOME/mr/available.d/zsh.vcsh
* $XDG_CONFIG_HOME/mr/config.d/mr.vcsh
* $XDG_CONFIG_HOME/vcsh/repo.d/mr.git/

All of the files are part of the template repository, the directory is where
the template will be stored.

    apt-get install mr

#### 3.1.2 Clone the Template ####

    mkdir -p ~/work/git
    cd !$
    git clone git://github.com/RichiH/vcsh.git vcsh
    cd vcsh
    ln -s vcsh /usr/local/bin        # or add it to your PATH
    cd
    vcsh clone git://github.com/RichiH/vcsh_mr_template.git mr.vcsh

#### 3.1.3 Enable Your Test Repository ####

    mv ~/.zsh   ~/zsh.bak
    mv ~/.zshrc ~/zshrc.bak
    cd $XDG_CONFIG_HOME/mr/config.d/
    ln -s ../available.d/zsh.vcsh .  # link, and thereby enable, the zsh repository
    cd
    mr up

#### 3.1.4 Set Up Your Own Repositories ####

Now, it's time to edit the template config and fill it with your own remotes:

    vim $XDG_CONFIG_HOME/mr/available.d/mr.vcsh
    vim $XDG_CONFIG_HOME/mr/available.d/zsh.vcsh

And then create your own stuff:

    vcsh init foo
    vcsh run foo git add -f bar baz quux
    vcsh run foo git remote add origin git://quuux
    vcsh run foo git commit
    vcsh run foo git push

    cp $XDG_CONFIG_HOME/mr/available.d/mr.vcsh $XDG_CONFIG_HOME/mr/available.d/foo.vcsh
    vim $XDG_CONFIG_HOME/mr/available.d/foo.vcsh # add your own repo

Done!

### 3.2 The Steal-from-Template Way ###

You're welcome to clone the example repository:

    git clone git://github.com/RichiH/vcsh_mr_template.git

Look around in the clone. It should be reasonably simple to understand. If not,
poke me, RichiH, on Freenode (query) or OFTC (#vcs-home).


### 3.3 The Manual Way ###

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

# 4 Usage #

### 4.1 Keeping repositories Up-to-Date ###

This is the beauty of it all. Once you are set up, just run:

    mr up
    mr push

Neat.

### 4.1 Making Changes ###

After you have made some changes, for which you would normally use `git add`
and `git commit`, use the vcsh wrapper (like above):

    vcsh run foo git add -f bar baz quux
    vcsh run foo git commit
    vcsh run foo git push

By the way, you'll have to use -f/--force flag with git-add because all files
will be ignored by default. This is to show you only useful output when running
git-status. A fix for this problem is being worked on.

### 4.3 Using vcsh without mr ###

vcsh encourages you to use mr. It helps you manage a large number of
repositories by running the necessary vcsh commands for you. You may choose not
to use mr, in which case you will have to run those commands manually or by
other means.

#### A Few Examples ####

To initialize a new repository: `vcsh init zsh`

To clone a repository: `vcsh clone ssh://<remote>/zsh.git`

To interact with a repository, use the regular Git commands, but prepend them
with `vcsh run $repository_name`. For example:

    vcsh run zsh git status
    vcsh run zsh git add -f .zshrc
    vcsh run zsh git commit

Obviously, without mr keeping repositories up-to-date, it will have to be done
manually. Alternatively, you could try something like this:

    for repo in `vcsh list`; do
        vcsh run $repo git pull;
    done

----------

mr can be found at: [http://kitenet.net/~joey/code/mr/][1]

[1]: http://kitenet.net/~joey/code/mr/ (http://kitenet.net/~joey/code/mr/)
