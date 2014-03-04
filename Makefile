PREFIX=/usr
DOCDIR_PREFIX=$(PREFIX)/share/doc
DOCDIR=$(DOCDIR_PREFIX)/$(self)
ZSHDIR=$(PREFIX)/share/zsh/vendor-completions
RONN ?= ronn

self=vcsh
vcsha=vcsha
manpages=$(self).1 $(vcsha).1
all=test

all: $(all)

install: all
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(self) $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(vcsha) $(DESTDIR)$(PREFIX)/bin
	install -d $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 0644 $(manpages) $(DESTDIR)$(PREFIX)/share/man/man1
	install -d $(DESTDIR)$(DOCDIR)
	install -m 0644 README.md $(DESTDIR)$(DOCDIR)
	install -m 0644 doc/hooks $(DESTDIR)$(DOCDIR)
	install -d $(DESTDIR)$(ZSHDIR)
	install -m 0644 _$(self) $(DESTDIR)$(ZSHDIR)

manpages: $(manpages)

$(self).1: doc/$(self).1.ronn
	$(RONN) < doc/$(self).1.ronn > $(self).1 || rm $(self).1

$(vcsha).1: doc/$(self).1.ronn
	$(RONN) < doc/$(self).1.ronn > $(self).1 || rm $(self).1

clean:
	rm -rf $(self).1 $(vcsha).a

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/bin/$(self)
	rm -rf $(DESTDIR)$(PREFIX)/bin/$(vcsha)
	rm -rf $(DESTDIR)$(PREFIX)/share/man/man1/$(self).1
	rm -rf $(DESTDIR)$(PREFIX)/share/man/man1/$(vcsha).1
	rm -rf $(DESTDIR)$(DOCDIR)
	rm -rf $(DESTDIR)$(ZSHDIR)/_$(self)

# Potentially harmful, used a non-standard option on purpose.
# If PREFIX=/usr/local and that's empty...
purge: uninstall
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/bin/
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/share/man/man1/
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(DOCDIR_PREFIX)
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(ZSHDIR)

test:
	@if which git > /dev/null ; then :; else echo "'git' not found, exiting..."; exit 1; fi

moo:
	@if [ -x /usr/games/cowsay ]; then /usr/games/cowsay "I hope you're happy now..."; fi
