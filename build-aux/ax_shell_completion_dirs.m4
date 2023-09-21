AC_DEFUN_ONCE([AX_SHELL_COMPLETION_DIRS], [

        AX_TRANSFORM_PACKAGE_NAME

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

        dnl  AC_ARG_WITH([fish-completion-dir],
        dnl          AS_HELP_STRING([--with-fish-completion-dir[=PATH]],
        dnl                  [Install the fish auto-completion script in this directory. @<:@default=yes@:>@]),
        dnl          [],
        dnl          [with_fish_completion_dir=yes])
        dnl  AM_CONDITIONAL([ENABLE_FISH_COMPLETION],[test "x$with_fish_completion_dir" != "xno"])

        dnl  AM_COND_IF([ENABLE_FISH_COMPLETION],
        dnl          [PKG_CHECK_MODULES([FISH_COMPLETION], [fish >= 3.0],
        dnl                  [FISH_COMPLETION_DIR="$(pkg-config --define-variable=datadir=$datadir --variable=completionsdir fish)"],
        dnl                  [FISH_COMPLETION_DIR="$datadir/fish/vendor_completions.d"])],
        dnl          [FISH_COMPLETION_DIR="$with_fish_completion_dir"])
        dnl  AC_SUBST([FISH_COMPLETION_DIR])

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

])
