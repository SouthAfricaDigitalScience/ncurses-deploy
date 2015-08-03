[![Build Status](http://ci.sagrid.ac.za:8080/buildStatus/icon?job=ncurses-deploy/ARCH=x86_64,OS=sl6,SITE=generic,VERSION=5.9&build=3)](http://ci.sagrid.ac.za:8080/job/ncurses-deploy/ARCH=x86_64,OS=sl6,SITE=generic,VERSION=5.9/3/)

# ncurses-devel README

This is the repository containing the build scripts for Jenkins to integrate ncurses into the CVMFS repository.

# How to use this repo


# Contents of the repo

This repo contains two scripts:

  1. `build.sh`
  2. `check-build.sh`

These define basically two test phases, the **build** and **functional** test phases respectively.

## Build Test Phase

The build phase does the following things

  1. Set up the build environment variables
  2. Check out the source code
  3. Configure the build
  4. Compile the source into an executable form.
  5. Create a modulefile which loads the dependencies and sets the environment variables needed to execute the application.

The build phase should pass iff the expected libraries and executable files are present. **It is your responsibility to define where these files are, on a case-by-case basis**.

## Functional test phase

The test phase does the following things :

  1. Loads the modulefile created by `build.sh`
  1. installs the libraries into the `$SOFT_DIR` directory
  2. Executes the application with a predefined input or configuration


# When things go wrong

If you have a legitimate error, or need support, please [open an issue](../../issues)
