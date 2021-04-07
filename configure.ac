AC_PREREQ([2.69])
AC_INIT([vcsh], [m4_esyscmd(build-aux/git-version-gen .tarball-version)])
AC_CONFIG_AUX_DIR([build-aux])
AM_INIT_AUTOMAKE([foreign tar-pax dist-xz dist-zip no-dist-gzip color-tests])
AM_SILENT_RULES([yes])
AC_CONFIG_MACRO_DIR([build-aux])

AC_PROG_AWK
AC_PROG_GREP
AC_PROG_SED

AC_DEFUN([AX_PROGVAR], [AC_PATH_PROG(m4_toupper($1), m4_default($2,$1))test -n "$m4_toupper($1)" || AC_MSG_ERROR([m4_default($2,$1) is required])])

AX_PROGVAR([comm])
AX_PROGVAR([cmp])
AX_PROGVAR([git])
AX_PROGVAR([prove])


AC_ARG_WITH([man-page],
    AS_HELP_STRING([--with-man-page],
        [Generate man page @<:@default=yes@:>@]),
    [],
    [with_man_page=yes])
if test "x$with_man_page" = "xyes"; then
	AX_PROGVAR([ronn])
fi
AM_CONDITIONAL([ENABLE_MAN_PAGE],[test "x$with_man_page" != "xno"])

AX_PROG_PERL_MODULES(Shell::Command, , AC_MSG_ERROR(Perl module required for testing not found))
AX_PROG_PERL_MODULES(Test::Most, , AC_MSG_ERROR(Perl module required for testing not found))

AC_ARG_WITH([bash-completion-dir],
    AS_HELP_STRING([--with-bash-completion-dir[=PATH]],
        [Install the bash auto-completion script in this directory. @<:@default=yes@:>@]),
    [],
    [with_bash_completion_dir=yes])
if test "x$with_bash_completion_dir" = "xyes"; then
    PKG_CHECK_MODULES([BASH_COMPLETION], [bash-completion >= 2.0],
        [BASH_COMPLETION_DIR="`pkg-config --variable=completionsdir bash-completion`"],
        [BASH_COMPLETION_DIR="$datadir/bash-completion/completions"])
else
    BASH_COMPLETION_DIR="$with_bash_completion_dir"
fi
AC_SUBST([BASH_COMPLETION_DIR])
AM_CONDITIONAL([ENABLE_BASH_COMPLETION],[test "x$with_bash_completion_dir" != "xno"])

AC_ARG_WITH([zsh-completion-dir],
    AS_HELP_STRING([--with-zsh-completion-dir[=PATH]],
        [Install the zsh auto-completion script in this directory. @<:@default=yes@:>@]),
    [],
    [with_zsh_completion_dir=yes])
if test "x$with_zsh_completion_dir" = "xyes"; then
    ZSH_COMPLETION_DIR="$datadir/zsh/site-functions"
else
    ZSH_COMPLETION_DIR="$with_zsh_completion_dir"
fi
AC_SUBST([ZSH_COMPLETION_DIR])
AM_CONDITIONAL([ENABLE_ZSH_COMPLETION],[test "x$with_zsh_completion_dir" != "xno"])

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([vcsh], [chmod +x vcsh])

AC_ARG_PROGRAM

AC_OUTPUT
