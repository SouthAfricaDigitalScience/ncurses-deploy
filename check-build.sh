module load ci
echo ""
cd $WORKSPACE/$NAME-$VERSION
make check

echo $?

make install # DESTDIR=$SOFT_DIR
DIRS=`ls $SOFT_DIR`
echo "DIRS to include in the tarball are $DIRS"
mkdir -p $REPO_DIR
rm -rf $REPO_DIR/*
tar -cvzf $REPO_DIR/build.tar.gz -C $SOFT_DIR $DIRS

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
prepend-path LD_LIBRARY_PATH   $::env(ncurses_DIR)/lib
prepend-path GCC_INCLUDE_DIR   $::env(ncurses_DIR)/include
MODULE_FILE
) > modules/$VERSION

mkdir -p $LIBRARIES_MODULES/$NAME
cp modules/$VERSION $LIBRARIES_MODULES/$NAME

module add list

module unload ci

module add ci
module avail # should have ncurses
module add ncurses

echo $LD_LIBRARY_PATH
