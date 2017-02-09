#!/bin/bash -e
. /etc/profile.d/modules.sh
module add ci
echo ""
cd ${WORKSPACE}/${NAME}-${VERSION}

echo $?

make install # DESTDIR=$SOFT_DIR
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION."
setenv       NCURSES_VERSION       $VERSION
setenv       NCURSES_DIR                  /data/ci-build/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(NCURSES_DIR)/lib
prepend-path  PATH                          $::env(NCURSES_DIR)/bin
MODULE_FILE
) > modules/${VERSION}

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}

module unload ci

module add ci
module avail # should have ncurses
# test the module
module add ${NAME}/#{VERSION}
