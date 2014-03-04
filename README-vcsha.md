Introduction
============

An add-on to allow VCSH (https://github.com/RichiH/vcsh) to manage
arbitrary directories.

VCSH is a tool that allows you to manage files in your $HOME in
multiple different git repositories.

This script is an addition that allow you to apply the same kind of
management to files in arbitrary directories *NOT* under $HOME.


Use
===

VCSHA attempts to be anaogous to the way git locates its repositories.

Use `vcsha init` in a directory to mark it for management by vcsha.

After that, use vcsha just as you would use vcsh but you will be
managing files underneath the marked directoriy.

Details
=======

As it stands, VCSH really wants to only manage files under $HOME.
However, it has a mechanism (enviornment variable "VCSH_BASE" (see
https://github.com/RichiH/vcsh/issues/112)) to work on other
directories.

This script uses a marker directory ".vcsha" in the file system to
locate a vcsh managed directory, sets VCSH_BASE and XDG_CONFIG_HOME
appropriately, then delegates all interesting work to vcsh.

This is useless without VCSH and is a fairly trivial addition to VCSH.
