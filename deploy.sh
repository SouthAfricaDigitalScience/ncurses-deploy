#!/bin/bash -e
# this should be run after check-build finishes.
. /etc/profile.d/modules.sh
echo ${SOFT_DIR}
module add deploy
# Now, dependencies
echo ${SOFT_DIR}
cd ${WORKSPACE}/${NAME}-${VERSION}
echo "All tests have passed, will now build into ${SOFT_DIR}"
CPPFLAGS='-P' CFLAGS='-fPIC' ./configure \
--with-shared \
--with-termlib \
--with-ticlib \
--enable-sp-funcs \
--enable-ext-colors \
--enable-ext-putwin \
--enable-tcap-names \
--enable-interop \
--prefix=${SOFT_DIR}
make install
mkdir -p ${LIBRARIES_MODULES}/${NAME}

# Now, create the module file for deployment
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION : See https://github.com/SouthAfricaDigitalScience/ncurses-deploy"
setenv       NCURSES_VERSION       $VERSION
setenv       NCURSES_DIR      $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(NCURSES_DIR)/lib
MODULE_FILE
) > ${LIBRARIES_MODULES}/${NAME}/${VERSION}
module purge

module add deploy
module avail ${NAME}
