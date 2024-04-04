# The autotools supplied AC_ARG_PROGRAM enables renaming operations, but it
# supplies them as a sed operation that can be applied to multiple binaries.
# This isn't convenient to use if we're just renaming the top level package, so
# we go ahead and *do* the transformation and save for use as a substitution.

AC_DEFUN_ONCE([QUE_TRANSFORM_PACKAGE_NAME], [

        AC_PROG_SED

        TRANSFORMED_PACKAGE_NAME="$(printf "$PACKAGE_NAME" | $SED -e "$(printf "$program_transform_name" | $SED -e 's/\$\$/\$/')")"
        AC_SUBST([TRANSFORMED_PACKAGE_NAME])

        PACKAGE_VAR="$(printf "$PACKAGE_NAME" | $SED -e "s/-/_/g")"
        AC_SUBST([PACKAGE_VAR])

        AC_ARG_PROGRAM

])
