# Like AM_MAINTAINER_MODE, but doesn't touch automake internals and so
# can be used freely to control access to project specific developer
# tooling without breaking autotools if disabled.
AC_DEFUN([QUE_DEVELOPER_MODE], [
        m4_case(m4_default([$1], [disable]),
                [enable], [m4_define([_que_developer_def], [disable])],
                [disable], [m4_define([_que_developer_def], [enable])],
                [m4_define([_que_developer_def], [enable])
                m4_warn([syntax], [unexpected argument to AM@&t@_DEVELOPER_MODE: $1])])
        AC_MSG_CHECKING([whether to enable developer-specific portions of Makefiles])
        AC_ARG_ENABLE([developer-mode],
                [AS_HELP_STRING([--]_que_developer_def[-developer-mode],
                        _que_developer_def[ dependencies and make targets only useful for developers])],
                [USE_DEVELOPER_MODE=$enableval],
                [USE_DEVELOPER_MODE=]m4_if(_que_developer_def, [enable], [no], [yes]))
        AC_MSG_RESULT([$USE_DEVELOPER_MODE])
        AM_CONDITIONAL([DEVELOPER_MODE], [test $USE_DEVELOPER_MODE = yes])

])
