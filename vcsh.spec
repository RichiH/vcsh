%global commit 36fc049881253a38f0b72d6d6aeb01c1295b8a2c
%global shortcommit %(c=%{commit}; echo ${c:0:7})

Name:           vcsh
Version:        1.20141026
Release:        1%{?dist}
Summary:        Version Control System for $HOME
Group:          Development/Tools

License:        GPLv2+
URL:            https://github.com/RichiH/vcsh
Source0:        https://github.com/RichiH/vcsh/archive/%{commit}/%{name}-%{version}-%{shortcommit}.tar.gz

BuildArch:      noarch
BuildRequires:  rubygem-ronn
Requires:       git


%description
vcsh allows you to have several git repositories, all maintaining their working
trees in $HOME without clobbering each other. That, in turn, means you can have
one repository per config set (zsh, vim, ssh, etc), picking and choosing which
configs you want to use on which machine.


%prep
%setup -qn %{name}-%{commit}


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
* Sun Oct 26 2014 Dridi Boukelmoune <dridi.boukelmoune@gmail.com> - 1.20141026-1
- Bumped version to 1.20141026

* Sun Jun 08 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.20140508-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_Mass_Rebuild

* Fri May 09 2014 Dridi Boukelmoune <dridi.boukelmoune@gmail.com> - 1.20140508-1
- Bumped version to 1.20140508
- Switched to a commit tarball from github

* Sun Dec 15 2013 Dridi Boukelmoune <dridi.boukelmoune@gmail.com> - 1.20131229-1
- Bumped version to 1.20131229

* Sun Dec 15 2013 Dridi Boukelmoune <dridi.boukelmoune@gmail.com> - 1.20131214-1
- Bumped version to 1.20131214

* Tue Oct 22 2013 Dridi Boukelmoune <dridi.boukelmoune@gmail.com> - 1.20130909-3
- The Makefile patch has been submitted upstream

* Sat Oct 19 2013 Dridi Boukelmoune <dridi.boukelmoune@gmail.com> - 1.20130909-2
- Switched to _pkgdocdir
- Removed unnecessary `rm -rf %%{buildroot}' in clean and install

* Sat Oct 12 2013 Dridi Boukelmoune <dridi.boukelmoune@gmail.com> - 1.20130909-1
- Initial package
