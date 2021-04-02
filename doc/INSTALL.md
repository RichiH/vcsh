# Pre-requisites #

If you want to build the manpage, you will need [ronn] [1].
Debian 7.0 and above come with a package, so do most Debian clones.

To install ronn on your Debian-based system, simply run

	apt-get install ruby-ronn

There are no other dependencies other than `git`, `ronn` and a POSIX shell.


# Installing #

	sudo make install

## Installing without root privileges ##

	make install DESTDIR=/home/myuser/local

or simply copy the shell script into any place you like, e.g. `~/bin`


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

To run the test suite, run

    make test

To run the test suite, you will need `perl`,
and the modules `Test::Most` and `Shell::Command`.

To install the perl modules, run

    cpan install 'Test::Most' 'Shell::Command'.


[1]: http://rtomayko.github.io/ronn/
