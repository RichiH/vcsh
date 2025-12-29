AC_DEFUN_ONCE([QUE_DIST_CHECKSUMS], [

        AM_COND_IF([DEVELOPER_MODE], [

                AX_REQUIRE_PROG([sha256sum])
                AX_REQUIRE_PROG([tee])

                QUE_TRANSFORM_PACKAGE_NAME

                AC_REQUIRE([AX_AM_MACROS])
                AX_ADD_AM_MACRO([dnl
$(cat build-aux/que_dist_checksums.am)
])dnl

        ])
])
