PREFIX=/usr

self=vcsh
manpages=$(self).1
all=test manpages

all: $(all)

install: all
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(self) $(DESTDIR)$(PREFIX)/bin
	install -d $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 0644 $(manpages) $(DESTDIR)$(PREFIX)/share/man/man1
	install -d $(DESTDIR)$(PREFIX)/share/doc/$(self)
	install -m 0644 README.md $(DESTDIR)$(PREFIX)/share/doc/$(self)
	install -m 0644 doc/hooks $(DESTDIR)$(PREFIX)/share/doc/$(self)
	install -d $(DESTDIR)$(PREFIX)/share/zsh/vendor-completions
	install -m 0644 _$(self) $(DESTDIR)$(PREFIX)/share/zsh/vendor-completions

manpages: $(manpages)

$(self).1: doc/$(self).1.ronn
	ronn < doc/$(self).1.ronn > $(self).1

clean:
	rm -rf $(self).1

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/bin/$(self)
	rm -rf $(DESTDIR)$(PREFIX)/share/man/man1/$(self).1
	rm -rf $(DESTDIR)$(PREFIX)/share/doc/$(self)
	rm -rf $(DESTDIR)$(PREFIX)/share/zsh/vendor-completions/_$(self)

# Potentially harmful, used a non-standard option on purpose.
# If PREFIX=/usr/local and that's empty...
purge: uninstall
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/bin/
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/share/man/man1/
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/share/doc/
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/share/zsh/vendor-completions/

test:
	if which git > /dev/null ; then :; else echo "'git' not found, exiting..."; exit 1; fi

moo:
	@if [ -x /usr/games/cowsay ]; then /usr/games/cowsay "I hope you're happy now..."; fi
