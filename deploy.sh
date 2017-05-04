#!/bin/bash -e
# Copyright 2016 C.S.I.R. Meraka Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# this should be run after check-build finishes.
. /etc/profile.d/modules.sh
echo ${SOFT_DIR}
module add deploy
# Now, dependencies
echo ${SOFT_DIR}
cd ${WORKSPACE}/${NAME}-${VERSION}
echo "All tests have passed, will now build into ${SOFT_DIR}"
# first, clean the previous config
make distclean
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

mkdir -p ${LIBRARIES}/${NAME}

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
setenv       NCURSES_DIR                 $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(NCURSES_DIR)/lib
prepend-path PATH                           $::env(NCURSES_DIR)/bin
MODULE_FILE
) > ${LIBRARIES}/${NAME}/${VERSION}
module purge

module add deploy
# Check the module
module avail ${NAME}
module add  ${NAME}/${VERSION}
