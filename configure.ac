AC_PREREQ([2.69])
AC_INIT([vcsh], [m4_esyscmd(build-aux/git-version-gen .tarball-version)])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([build-aux])
AM_INIT_AUTOMAKE([foreign tar-pax dist-zstd dist-zip no-dist-gzip color-tests])
AM_SILENT_RULES([yes])

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
             # By this point, ./configure has already handled its built in
             # arguments and hence thinks program_suffix has made its way into
             # program_transform_name. We're backtracking on it, so we have to
             # do the work again manually.
             # Code copied from generated ./configure at approx L2104 and 2108...
             program_transform_name="s&\$&$program_suffix&;$program_transform_name"
             program_transform_name=`printf "%s\n" "$program_transform_name" | sed "$ac_script"`
            ],
            [])

QUE_TRANSFORM_PACKAGE_NAME
QUE_DEVELOPER_MODE

# These macros must be run after processing our standalone setup because
# they all expect the program name transformation setup to be complete.
QUE_GIT_VERSION
QUE_SHELL_COMPLETION_DIRS
QUE_DIST_CHECKSUMS

AC_PROG_GREP
AC_PROG_SED

QUE_PROGVAR([comm])
QUE_PROGVAR([git])
QUE_PROGVAR([wc])

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

AM_COND_IF([SOURCE_IS_GIT],
           [AM_COND_IF([ENABLE_MAN_PAGE],
                       [QUE_PROGVAR([ronn])])
])

AM_COND_IF([SOURCE_IS_GIT],
           m4_define([TESTDEF], [yes]),
           m4_define([TESTDEF], [no]))
AC_ARG_ENABLE([tests],
              AS_HELP_STRING([--disable-tests],
                             [Configure tooling to run tests @<:@default=TESTDEF@:>@]),
              [],
              [enable_tests=TESTDEF])
AM_CONDITIONAL([ENABLE_TESTS],
               [test x"$enable_tests" != x"no"])

AM_COND_IF([ENABLE_TESTS], [
       QUE_PROGVAR([prove])
       AX_PROG_PERL_MODULES(Shell::Command, [],
                            AC_MSG_ERROR(Perl module required for testing not found))
       AX_PROG_PERL_MODULES(Test::Most, [],
                            AC_MSG_ERROR(Perl module required for testing not found))
])

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([vcsh], [chmod +x vcsh])
AC_CONFIG_FILES([doc/vcsh.1.ronn])

AC_OUTPUT
