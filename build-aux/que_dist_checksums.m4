AC_DEFUN_ONCE([QUE_DIST_CHECKSUMS], [

        QUE_PROGVAR([sha256sum])
        QUE_PROGVAR([tee])

        QUE_TRANSFORM_PACKAGE_NAME

        AC_REQUIRE([AX_AM_MACROS])
        AX_ADD_AM_MACRO([dnl
$(cat build-aux/que_dist_checksums.am)
])dnl

])
