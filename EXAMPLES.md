# Getting started with vcsh #

Below, you will find a few different methods for setting up vcsh:

1. The template way
2. The steal-from-template way
3. The manual way
4. Using vcsh without mr

# 1. The template way #

## 1.1 Prerequisites ##

Make sure none of the following files/diretories exist for your test (user). If
they do, move them away for now:

* ~/.gitignore
* ~/.mrconfig
* ~/.config/mr/available.d/mr.vcsh
* ~/.config/mr/available.d/zsh.vcsh
* ~/.config/mr/config.d/mr.vcsh
* ~/.config/vcsh/repo.d/mr.git/

All of the files are part of the template repository, the directory is where
the template will be stored.

    apt-get install mr               # this is optional, but highly recommended

## 1.2 Clone the template ##

    mkdir -p ~/work/git
    cd !$
    git clone git://github.com/RichiH/vcsh.git vcsh
    cd vcsh
    ln -s vcsh /usr/local/bin        # or add it to your PATH
    cd
    vcsh clone git://github.com/RichiH/vcsh_mr_template.git mr.vcsh

## 1.3 Enable your test repository ##

    mv ~/.zsh   ~/zsh.bak
    mv ~/.zshrc ~/zshrc.bak
    cd ~/.config/mr/config.d/
    ln -s ../available.d/zsh.vcsh .  # link, and thereby enable, the zsh repository
    cd
    mr up

## 1.4 Set up your own repositories ##

Now, it's time to edit the template config and fill it with your own remotes:

    vim .config/mr/available.d/mr.vcsh
    vim .config/mr/available.d/zsh.vcsh

And then create your own stuff:

    vcsh init foo
    vcsh run foo git add -f bar baz quux
    vcsh run foo git remote add origin git://quuux
    vcsh run foo git commit
    vcsh run foo git push

    cp .config/mr/available.d/mr.vcsh .config/mr/available.d/foo.vcsh
    vim .config/mr/available.d/foo.vcsh # add your own repo

Done!

## 1.5 Daily use  ##

### 1.5.1 Keeping repositories up-to-date ###

This is the beauty of it all. Once you are set up, just run:

   mr up
   mr push

Neat.

### 1.5.2 Making changes ###

After you have made some changes, for which you would normally use `git add`
and `git commit`, use the vcsh wrapper (like above):

    vcsh run foo git add -f bar baz quux
    vcsh run foo git commit
    vcsh run foo git push

By the way, you'll have to use -f/--force flag with git-add because all files
will be ignored by default. This is to show you only useful output when running
git-status. A fix for this problem is being worked on.


# 2. The steal-from-template way #

You're welcome to clone the example repository:

    git clone git://github.com/RichiH/vcsh_mr_template.git

Look around in the clone. It should be reasonably simple to understand. If not,
poke me, RichiH, on Freenode (query) or OFTC (#vcs-home).


# 3. The manual way #

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
    cd ~/.config/mr/config.d/
    ln -s ../available.d/* .


mr is used to actually retrieve configs, etc

    ~ % cat ~/.mrconfig
    [DEFAULT]
    include = cat ~/.config/mr/config.d/*
    ~ % echo $XDG_CONFIG_HOME
    /home/richih/.config
    ~ % ls $XDG_CONFIG_HOME/mr/available.d # random selection of my repos
    git-annex gitk.vcsh git.vcsh ikiwiki mr.vcsh reportbug.vcsh snippets.git wget.vcsh zsh.vcsh
    ~ %
    # then simply ln -s whatever you want on your local machine from
    # $XDG_CONFIG_HOME/mr/available.d to $XDG_CONFIG_HOME/mr/config.d
    ~ % cd
    ~ % mr -j 5 up

# 4. Using vcsh without mr #

vcsh encourages you to use mr. It helps you manage a large number of
repositories by running the necessary vcsh commands for you. You may choose not
to use mr, in which case you will have to run those commands manually or by
other means.

## 4.1 A few examples ##

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
Questions? RichiH@{Freenode,OFTC,IRCnet}
