vcsh - manage and sync config files via git

# Introduction #

vcsh allows you to have several git repositories, all maintaining their working trees in $HOME without clobbering each other.
That, in turn, means you can have one repository per config set (zsh, vim, ssh, etc), picking and choosing which configs you want to use on which machine.

vcsh was designed with mr [1] in mind so you might want to install that, as well.

Read INSTALL.md for detailed setup instructions.

Questions? RichiH@{Freenode,OFTC,IRCnet}

## Comparison to Other Solutions ##

Most people who decide to put their dotfiles under version control start with a **single repository in $HOME**, adding all their dotfiles (and possibly more) to it.
This works, of course, but can become a nuisance as soon as you try to manage more than one host.

The next logical step is to create single-purpose repositories in, for example, ~/.dotfiles and to create **symbolic links in $HOME**.
This gives you the flexibility to check out only certain repositories on different hosts.
The downsides of this approach are the necessary manual steps of cloning and symlinking the individual repositories.
It will probably become a nuisance when you try to manage more than two hosts.

vcsh takes this second approach one step further.
It expects single-purpose repositories and stores them in a hidden directory (similar to ~/.dotfiles).
However, it does not create symbolic links in $HOME; it puts the actual files right into $HOME.

Furthermore, by making use of mr [1], it makes it very easy to enable/disable and clone a large number of repositories.
The use of mr is technically optional, but it will be an integral part of the proposed system that follows.

## Default Directory Layout ##

To illustrate, this is what a possible directory structure looks like.

        $HOME
            |-- .config
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
            |   |   |   |-- snippets.git
            |   |   |-- config.d
            |   |   |   |-- zsh.mrconfig       -> ../available.d/zsh.mrconfig
            |   |   |   |-- gitconfigs.mrconfig -> ../available.d/gitconfigs.mrconfig
            |   |   |   |-- tmux.mrconfig       -> ../available.d/tmux.mrconfig
            |   |   |   `-- vim.mrconfig        -> ../available.d/vim.mrconfig
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

In this setup, ~/.mrconfig looks like:

        [DEFAULT]
        jobs = 5
        include = cat ~/.config/mr/config.d/*

The files you see in ~/.config/mr/available.d are mr configuration files that contain the commands to manage (checkout, update etc.) a single repository.
vcsh repo configs end in .vcsh, git configs end in .git, etc. This is optional and your preference.
For example, this is what a zsh.mrconfig with read-only access to my zshrc repo looks likes. I.e. in this specific example, push can not work.

        [$HOME/.config/vcsh/repo.d/zsh.git]
        checkout = vcsh clone 'git://github.com/RichiH/zshrc.git'
        update = vcsh run bash git pull
        push = vcsh run bash git push
        status = vcsh run bash git status

~/.config/mr/available.d contains *all available* repositories.
Only files/links present in mr/config.d, however, will be used by mr.
That means that in this example, only the zsh, gitconfigs, tmux and vim repositories will be checked out.
A simple `mr update` run in $HOME will clone or update those four repositories listed in config.d.

~/.config/vcsh/repo.d is the directory where vcsh clones the git repositories into.
Since their working trees are configured to be in $HOME, the files contained in those repositories will be put in $HOME directly (see .bashrc above).

vcsh will check if any file it would want to create exists. If it exists, vcsh will throw a warning and exit. Move away your old config and try again. Optionally, merge your local and your global configs afterwards and push with `vcsh run foo git push`.

## Moving into a New Host ##

To illustrate further, the following steps could move your desired configuration to a new host.

1. Clone the mr repository (containing available.d, config.d etc.), for example: `vcsh clone git://github.com/RichiH/vcsh_mr_template.git`
2. Choose your repositories by linking them in config.d (or go with the default you may have already configured by adding symlinks to git).
3. Run mr to clone the repositories: `cd; mr update`.
4. Done.

Hopefully the above could help explain how this approach saves time by

1. making it easy to manage, clone and update a large number of repositories (thanks to mr) and
2. making it unnecessary to create symbolic links in $HOME (thanks to vcsh).

----------

[1] http://kitenet.net/~joey/code/mr/
