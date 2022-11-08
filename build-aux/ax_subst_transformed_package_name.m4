AC_DEFUN([AX_SUBST_TRANSFORMED_PACKAGE_NAME], [
          AC_PROG_SED
          TRANSFORMED_PACKAGE_NAME="$(printf "$PACKAGE_NAME" | $SED -e "$(printf "$program_transform_name" | $SED -e 's/\$\$/\$/')")"
          AC_SUBST([TRANSFORMED_PACKAGE_NAME])
])
