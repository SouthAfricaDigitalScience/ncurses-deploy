#!/bin/bash -e
. /etc/profile.d/modules.sh
module load ci
echo ""
cd ${WORKSPACE}/${NAME}-${VERSION}

echo $?

make install # DESTDIR=$SOFT_DIR
DIRS=`ls $SOFT_DIR`
echo "DIRS to include in the tarball are $DIRS"
mkdir -p ${REPO_DIR}
rm -rf ${REPO_DIR}/*
tar -cvzf ${REPO_DIR}/build.tar.gz -C ${SOFT_DIR} ${DIRS}

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
setenv       NCURSES_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(NCURSES_DIR)/lib
prepend-path GCC_INCLUDE_DIR   $::env(NCURSES_DIR)/include
MODULE_FILE
) > modules/${VERSION}

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}

module add list

module unload ci

module add ci
module avail # should have ncurses
module add ncurses

echo ${LD_LIBRARY_PATH}

# We have checked it locally, now we should make one that can be uses remotely.

echo "Making devrepo module"
mkdir -p devrepo-modules

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
setenv       NCURSES_DIR           $CVMFS_DIR/devrepo.sagrid.ac.za/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(NCURSES_DIR)/lib
prepend-path GCC_INCLUDE_DIR   $::env(NCURSES_DIR)/include
MODULE_FILE
) > devrepo-modules/${VERSION}

module add devrepo
mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}
