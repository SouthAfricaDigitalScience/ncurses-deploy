#!/bin/bash -e
. /etc/profile.d/modules.sh
# This is the demo version of a build script for the SAGrid Jenkins instance. Customise it for your needs

# If you are building from tarball, such as code obtained from sourceforge or github releases, you can use the
# NAME and VERSION variables defined in the Jenkins job to get the right package for you.
# Be careful of capitalisation and semantic versioning differences
# E.g. ApplicationName-v.1.2.3 is different from application-name-1.2.3 and so on.

SOURCE_FILE=${NAME}-${VERSION}.tar.gz

# We provide the base module which all jobs need to get their environment on the build slaves
module add ci
# Next, a bit of verbose description of the build environment. This is useful when debugging initial builds and you
# may want to remove it later.

# this tells you the main variables you can use which are set by the ci module
echo "REPO_DIR is "
echo ${REPO_DIR}
echo "SRC_DIR is "
echo ${SRC_DIR}
echo "WORKSPACE is "
echo ${WORKSPACE}
echo "SOFT_DIR is"
echo ${SOFT_DIR}


# In order to get started, we need to ensure that the following directories are available

# Workspace is the "home" directory of jenkins into which the project itself will be created and built.
mkdir -p ${WORKSPACE}
# SRC_DIR is the local directory to which all of the source code tarballs are downloaded. We cache them locally.
mkdir -p ${SRC_DIR}
# SOFT_DIR is the directory into which the application will be "installed"
mkdir -p ${SOFT_DIR}

#  Download the source file if it's not available locally.

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "seems like this is the first build - let's get the source"
  mkdir -p ${SRC_DIR}
# use local mirrors if you can. Remember - UFS has to pay for the bandwidth!
  wget http://mirror.ufs.ac.za/gnu/gnu/${NAME}/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
else
  echo "continuing from previous builds, using source at " $SRC_DIR/$SOURCE_FILE
fi

# now unpack it into the workspace
tar -xvzf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files

#  generally tarballs will unpack into the NAME-VERSION directory structure. If this is not the case for your application
#  ie, if it unpacks into a different default directory, either use the relevant tar commands, or change
#  the next lines

# We will be running configure and make in this directory
cd ${WORKSPACE}/${NAME}-${VERSION}
# Note that $SOFT_DIR is used as the target installation directory.
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

make -j 2
