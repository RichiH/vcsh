AC_DEFUN_ONCE([QUE_GIT_VERSION], [

        AM_CONDITIONAL([SOURCE_IS_GIT],
                [test -d .git])

        AM_CONDITIONAL([SOURCE_IS_DIST],
                [test -f .tarball-version])

        AM_CONDITIONAL([SOURCE_IS_ARCHIVE],
                [test ! -d .git -a ! -f .tarball-version])

        AC_PROG_AWK
        AC_PROG_GREP

        QUE_TRANSFORM_PACKAGE_NAME

        AM_COND_IF([SOURCE_IS_DIST], [], [QUE_PROGVAR([cmp])])

        AC_REQUIRE([AX_AM_MACROS])
        AX_ADD_AM_MACRO([dnl
$(cat build-aux/que_git_version.am)
])dnl

])
