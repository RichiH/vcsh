AC_PREREQ([2.69])
AC_INIT([vcsh], [m4_esyscmd(build-aux/git-version-gen .tarball-version)])
AC_CONFIG_AUX_DIR([build-aux])
AM_INIT_AUTOMAKE([foreign tar-pax dist-xz dist-zip no-dist-gzip color-tests])
AM_SILENT_RULES([yes])
AC_CONFIG_MACRO_DIR([build-aux])

AM_CONDITIONAL([IS_SDIST],
               [test -e .tarball-version])

AC_DEFUN([AX_PROGVAR], [
          test -n "$m4_toupper($1)" || { AC_PATH_PROG(m4_toupper($1), m4_default($2,$1)) }
          test -n "$m4_toupper($1)" || AC_MSG_ERROR([m4_default($2,$1) is required])
          ])

AC_ARG_WITH([standalone],
            AS_HELP_STRING([--with-standalone],
                           [Use configuration presets for a standalone script deployment @<:@default=no@:>@]),
            [COMM=comm GIT=git GREP=grep SED=sed WC=wc SHELL=/bin/sh
             with_deployment=standalone
             with_man_page=no
             enable_tests=no
             with_bash_completion_dir=no
             with_zsh_completion_dir=no
             program_suffix=-standalone.sh
             # By this point program_suffix has already been processed so we have to redo what configure did
             # Code copied from approx L2670-2671
             program_transform_name="s&\$&$program_suffix&;$program_transform_name"
             program_transform_name=`printf "%s\n" "$program_transform_name" | sed "$ac_script"`
            ],
            [])

AC_PROG_AWK
AC_PROG_GREP
AC_PROG_SED

AX_PROGVAR([comm])
AX_PROGVAR([cmp])
AX_PROGVAR([git])
AX_PROGVAR([wc])

AC_ARG_WITH([deployment],
            AS_HELP_STRING([--with-deployment],
                           [Add deployment string to version @<:@default=@:>@]),
            [],
            [with_deployment=])
AC_SUBST([DEPLOYMENT], [${with_deployment:+-$with_deployment}])

AC_ARG_WITH([man-page],
            AS_HELP_STRING([--with-man-page],
                           [Generate man page @<:@default=yes@:>@]),
            [],
            [with_man_page=yes])
AM_CONDITIONAL([ENABLE_MAN_PAGE],
               [test x"$with_man_page" != x"no"])

AM_COND_IF([IS_SDIST],
           [],
           [AM_COND_IF([ENABLE_MAN_PAGE],
                       [AX_PROGVAR([ronn])])
])

AM_COND_IF([IS_SDIST],
           m4_define([TESTDEF], [yes]),
           m4_define([TESTDEF], [no]))
AC_ARG_ENABLE([tests],
              AS_HELP_STRING([--disable-tests],
                             [Configure tooling to run tests @<:@default=TESTDEF@:>@]),
              [],
              [enable_tests=TESTDEF])
AM_CONDITIONAL([ENABLE_TESTS],[test x"$enable_tests" != x"no"])

AS_IF([test x"$enable_tests" != x"no"], [
       AX_PROGVAR([prove])
       AX_PROG_PERL_MODULES(Shell::Command, [],
                            AC_MSG_ERROR(Perl module required for testing not found))
       AX_PROG_PERL_MODULES(Test::Most, [],
                            AC_MSG_ERROR(Perl module required for testing not found))
])

AC_ARG_WITH([bash-completion-dir],
            AS_HELP_STRING([--with-bash-completion-dir[=PATH]],
                           [Install bash auto-completion definitions to a directory. @<:@default=yes@:>@]),
            [],
            [with_bash_completion_dir=yes])
AS_IF([test x"$with_bash_completion_dir" = x"yes"],
      [PKG_CHECK_MODULES([BASH_COMPLETION], [bash-completion >= 2.0],
                         [BASH_COMPLETION_DIR="$(pkg-config --define-variable=datadir=$datadir --variable=completionsdir bash-completion)"],
                         [BASH_COMPLETION_DIR="$datadir/bash-completion/completions"])],
      [BASH_COMPLETION_DIR="$with_bash_completion_dir"])
AC_SUBST([BASH_COMPLETION_DIR])
AM_CONDITIONAL([ENABLE_BASH_COMPLETION],
               [test x"$with_bash_completion_dir" != x"no"])

AC_ARG_WITH([zsh-completion-dir],
            AS_HELP_STRING([--with-zsh-completion-dir[=PATH]],
                           [Install zsh auto-completion definitions to a directory. @<:@default=yes@:>@]),
            [],
            [with_zsh_completion_dir=yes])
if test x"$with_zsh_completion_dir" = x"yes"; then
    ZSH_COMPLETION_DIR="$datadir/zsh/site-functions"
else
    ZSH_COMPLETION_DIR="$with_zsh_completion_dir"
fi
AC_SUBST([ZSH_COMPLETION_DIR])
AM_CONDITIONAL([ENABLE_ZSH_COMPLETION],
               [test x"$with_zsh_completion_dir" != x"no"])

TRANSFORMED_PACKAGE_NAME="$(printf "$PACKAGE_NAME" | $SED -e "${program_transform_name//\$\$/\$}")"
AC_SUBST([TRANSFORMED_PACKAGE_NAME])

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([vcsh], [chmod +x vcsh])
AC_CONFIG_FILES([doc/vcsh.1.ronn])

AC_ARG_PROGRAM

AC_OUTPUT
