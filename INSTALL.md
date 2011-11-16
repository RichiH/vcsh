# Pre-requisites #

If you want to build the manpage, you will need ronn. Newer versions of Debian come with a package:

    apt-get install ruby-ronn


# Installing #

    sudo make install


# Uninstalling #

    sudo make uninstall

There is another, more thorough, version. Just make sure you are not running this when you have installed to an important directory which is empty, otherwise.

**THIS WILL DELETE /usr/local IF YOU INSTALLED THERE AND IT'S EMPTY, OTHERWISE**

    sudo make purge

**THIS WILL DELETE /usr/local IF YOU INSTALLED THERE AND IT'S EMPTY, OTHERWISE**

This is not in the default behaviour of `make uninstall` for obvious reasons.


# Other stuff #

To clean up the generated manpag, run

    make clean

and if you are bored, I suggest

    make moo
