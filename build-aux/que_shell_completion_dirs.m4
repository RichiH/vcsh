AC_DEFUN_ONCE([QUE_SHELL_COMPLETION_DIRS], [

        QUE_TRANSFORM_PACKAGE_NAME

        AC_PROG_SED

        AC_ARG_WITH([bash-completion-dir],
                AS_HELP_STRING([--with-bash-completion-dir[=PATH]],
                        [Install the bash auto-completion script in this directory. @<:@default=yes@:>@]),
                [],
                [with_bash_completion_dir=yes])
        AM_CONDITIONAL([ENABLE_BASH_COMPLETION],
                [test "x$with_bash_completion_dir" != "xno"])

        AM_COND_IF([ENABLE_BASH_COMPLETION],
                [PKG_CHECK_MODULES([BASH_COMPLETION], [bash-completion >= 2.0],
                                [BASH_COMPLETION_DIR="$(pkg-config --define-variable=datadir=$datadir --variable=completionsdir bash-completion)"],
                                [BASH_COMPLETION_DIR="$datadir/bash-completion/completions"])],
                [BASH_COMPLETION_DIR="$with_bash_completion_dir"])
        AC_SUBST([BASH_COMPLETION_DIR])

        AC_ARG_WITH([zsh-completion-dir],
                AS_HELP_STRING([--with-zsh-completion-dir[=PATH]],
                        [Install the zsh auto-completion script in this directory. @<:@default=yes@:>@]),
                [],
                [with_zsh_completion_dir=yes])
        AM_CONDITIONAL([ENABLE_ZSH_COMPLETION],
                [test "x$with_zsh_completion_dir" != "xno"])

        AM_COND_IF([ENABLE_ZSH_COMPLETION],
                [ZSH_COMPLETION_DIR="$datadir/zsh/site-functions"],
                [ZSH_COMPLETION_DIR="$with_zsh_completion_dir"])
        AC_SUBST([ZSH_COMPLETION_DIR])

        AC_REQUIRE([AX_AM_MACROS])
        AX_ADD_AM_MACRO([dnl
$(cat build-aux/que_shell_completion_dirs.am)
])dnl

])
