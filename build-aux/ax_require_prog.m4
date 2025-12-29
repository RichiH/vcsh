# ===========================================================================
#     https://www.gnu.org/software/autoconf-archive/ax_require_prog.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_REQUIRE_PROG([EXECUTABLE], [VARIABLE])
#
# DESCRIPTION
#
#   Locates an installed binary program that is a prerequisite to continue.
#   Uses AX_WITH_PROG under the hood, but follows up the check with an error
#   if no executable could be located.
#
#   Example usage:
#
#     AX_REQUIRE_PROG(git-warp-time)
#
#   Note: If the second argument is not provided, a default value of
#   VARIABLE is automatically derived from the executable name by upper
#   casing it and substituting any dashes or periods with underscores. In
#   the example above the resulting precious variable would be
#   GIT_WARP_TIME.
#
# LICENSE
#
#   Copyright (c) 2021 Caleb Maclennan <caleb@alerque.com>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 1

AC_DEFUN([AX_REQUIRE_PROG], [
    AC_PREREQ([2.61])

    pushdef([EXECUTABLE],$1)
    pushdef([VARIABLE],m4_default($2,m4_toupper(m4_translit($1,-.,__))))

    AX_WITH_PROG(VARIABLE,EXECUTABLE)
    AS_IF([test "x$with_$1" != xno && test -z "$VARIABLE"], [
        AC_MSG_ERROR([EXECUTABLE is required])
    ])

    popdef([VARIABLE])
    popdef([EXECUTABLE])
])
