# ncurses-deploy README

[![Build Status](https://ci.sagrid.ac.za/buildStatus/icon?job=ncurses-deploy)](https://ci.sagrid.ac.za/job/ncurses-deploy) [![DOI](https://zenodo.org/badge/40120092.svg)](https://zenodo.org/badge/latestdoi/40120092)

This is the repository containing the build scripts for Jenkins to integrate [ncurses](https://www.gnu.org/software/ncurses/) into the CVMFS repository. This builds versions :

  1. ~~V 5.9~~
  1. v6.0
  1. v6.1


# How to use this repo

Write the scripts which build, test and deploy ncurses (and only ncurses). See below for details.

## Contents of the repo

This repo contains two scripts:

  1. `build.sh`
  2. `check-build.sh`
  3. `deploy.sh`

These define basically two test phases, the **build** and **functional** test phases, as well as the deployment phase respectively.

### Build Test Phase

The build phase does the following things

  1. Add dependent modules
  1. Set up the build environment variables
  2. Check out the source code
  3. Configure the build
  4. Compile the source into an executable form.
  5. Create a modulefile which loads the dependencies and sets the environment variables needed to execute the application.

A module `ci` is provided for this part of the build (`module add ci`). The build phase should pass iff the expected libraries and executable files are present. **It is your responsibility to define where these files are, on a case-by-case basis**.

### Functional test phase

The test phase does the following things :

  1. Loads the modulefile created by `build.sh`
  1. installs the libraries into the `$SOFT_DIR` directory
  2. Executes the application with a predefined input or configuration

## Deployment phase

If all of the tests have passed, the application can be recompiled with the deployment target. This entails loading the `deploy` module, instead of the `ci` module, and recompiling with the same configuration and flags. The only difference is  the install directory.

# When things go wrong

If you have a legitimate error, or need support, please [open an issue](../../issues)

Otherwise, [open a topic on the forum](https://discourse.sci-gaia.eu)

# Citing

Cite as :

Bruce Becker. (2017). SouthAfricaDigitalScience/ncurses-deploy: CODE-RADE Foundation Release 3 - ncurses [Data set]. Zenodo. http://doi.org/10.5281/zenodo.571432
