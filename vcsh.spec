Name:           vcsh
Version:        1.20130909
Release:        3%{?dist}
Summary:        Version Control System for $HOME
Group:          Development/Tools

License:        GPLv2+
URL:            https://github.com/RichiH/vcsh
Source0:        https://github.com/RichiH/vcsh/archive/v%{version}.tar.gz
Patch0:         https://github.com/RichiH/vcsh/pull/90.diff

BuildArch:      noarch
BuildRequires:  rubygem-ronn
Requires:       git


%description
vcsh allows you to have several git repositories, all maintaining their working
trees in $HOME without clobbering each other. That, in turn, means you can have
one repository per config set (zsh, vim, ssh, etc), picking and choosing which
configs you want to use on which machine.


%prep
%setup -q
%patch0 -p1


%build
make %{?_smp_mflags} all=manpages


%install
%{make_install} all=manpages DOCDIR=%{_pkgdocdir} ZSHDIR=%{_datadir}/zsh/site-functions


%files
%defattr(-, root, root, -)
%doc LICENSE CONTRIBUTORS changelog
%{_bindir}/%{name}
%{_mandir}/man*/%{name}*
%{_datadir}/zsh/


%changelog
* Tue Oct 22 2013 Dridi Boukelmoune <dridi.boukelmoune@gmail.com> - 1.20130909-3
- The Makefile patch has been submitted upstream

* Sat Oct 19 2013 Dridi Boukelmoune <dridi.boukelmoune@gmail.com> - 1.20130909-2
- Switched to _pkgdocdir
- Removed unnecessary `rm -rf %{buildroot}' in clean and install

* Sat Oct 12 2013 Dridi Boukelmoune <dridi.boukelmoune@gmail.com> - 1.20130909-1
- Initial package
