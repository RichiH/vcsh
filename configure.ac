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
AX_PROGVAR([git])
AX_PROGVAR([ronn])

AC_DEFUN([AX_PROGVAR], [AC_PATH_PROG(m4_toupper($1), m4_default($2,$1))test -n "$m4_toupper($1)" || AC_MSG_ERROR([m4_default($2,$1) is required])])

AX_PROGVAR([cmp])

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([vcsh], [chmod +x vcsh])

AC_ARG_PROGRAM

AC_OUTPUT
