AC_PREREQ([2.69])
AC_INIT([vcsh], [m4_esyscmd(build-aux/git-version-gen .tarball-version)])
AC_CONFIG_AUX_DIR([build-aux])
AM_INIT_AUTOMAKE

AC_PROG_AWK

AC_DEFUN([AX_PROGVAR], [AC_PATH_PROG(m4_toupper($1), m4_default($2,$1))test -n "$m4_toupper($1)" || AC_MSG_ERROR([m4_default($2,$1) is required])])

AX_PROGVAR([cmp])

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([vcsh], [chmod +x vcsh])

AC_OUTPUT
