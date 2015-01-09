# Pre-requisites #

There are no other dependencies other than git and a POSIX shell.


# Installing #

	sudo make install


# Uninstalling #

	sudo make uninstall

There is another, more thorough, version. Just make sure you are not running
this when you have installed to an important directory which is empty,
otherwise.

**THIS WILL DELETE /usr/local IF YOU INSTALLED THERE AND IT BECOMES EMPTY**

	sudo make purge

**THIS WILL DELETE /usr/local IF YOU INSTALLED THERE AND IT BECOMES EMPTY**

This is not in the default behaviour of `make uninstall` for obvious reasons.


# Other stuff #

To clean up the generated manpage, run

	make clean

and if you are bored, I suggest

	make moo

