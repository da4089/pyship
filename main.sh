#!/bin/bash

# Simple output directory that has static python and virtualenv

set -eo pipefail
shopt -s extglob

SOURCE=$( readlink "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}" )
ROOT=$( cd "$( dirname "$SOURCE" )" && pwd )

BUILD_DIR="$ROOT/build"
DEPS_DIR="$ROOT/build/deps"
DIST_DIR="$ROOT/build/pyship"
DIST_TARGZ="$(basename "$DIST_DIR")".tar.gz

PY_BUILD_DIR="$BUILD_DIR/pybuild"
PY_THIRD_PARTY="$DEPS_DIR/pythirdparty"

SDK_PATH=$(xcrun --show-sdk-path)

if [ -z "$1" ]
then
    printf "error: usage, $0 <deployment-target>" >2
    exit 1
fi
DEP_TARGET=$1
set -u


#########################
# Setup build directory #
#########################
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
mkdir -p "$DEPS_DIR"
rm -rf !("$(basename "$DEPS_DIR")")
mkdir "$DIST_DIR"


###############################################
# Get cpython into the distribution directory #
###############################################
cd "$DEPS_DIR"
if [ ! -d "cpython" ]
then
    git clone git@github.com:PreVeil/cpython.git
fi
(
cd cpython
git checkout preveil-2.7
cd Mac/BuildScript/
./build-installer.py                    \
    --universal-archs=intel             \
    --sdk-path="$SDK_PATH"              \
    --dep-target="$DEP_TARGET"          \
    --build-dir="$PY_BUILD_DIR"         \
    --third-party="$PY_THIRD_PARTY"

cp -R "$PY_BUILD_DIR/_root" "$DIST_DIR/python2.7"
)


##################################################
# Get virtualenv into the distribution directory #
##################################################
if [ ! -d "virtualenv" ]
then
    git clone git@github.com:pypa/virtualenv.git
fi
(
cd virtualenv
git checkout 15.0.1
)
cp -R virtualenv "$DIST_DIR/virtualenv"
rm -rf "$DIST_DIR/virtualenv/.git"

cd "$DIST_DIR/.."
tar -zcvf "$DIST_TARGZ" "$(basename "$DIST_DIR")"


#####################################################
# Tell the user how his fortunes have just improved #
#####################################################
printf "\n\n\n\e[1;92mPython build complete:\e[m %s\n\n" "$BUILD_DIR/$DIST_TARGZ"
printf "\e[1;92mTo setup a virtualenv using your semi-statically linked python\e[m\n"
printf "\t$ tar -zxf %s\n" "$DIST_TARGZ"
printf "\t$ ./%s/python2.7/usr/local/bin/python  \\ \n" "$(basename "$DIST_TARGZ" .tar.gz)"
printf "\t  ./%s/virtualenv/virtualenv.py    \\ \n" "$(basename "$DIST_TARGZ" .tar.gz)"
printf "\t  my-virtualenv\n\n"
printf "\e[1;92mNow install packages and run your software\e[m\n"
printf "\t$ ./my-virtualenv/bin/pip install 'PyYaml==3.11'\n"
printf "\t$ ./my-virtualenv/bin/python -c     \\ \n"
printf "\t\t\"import yaml; print yaml.dump({'Hello World': [1,2,3]})\"\n"
printf "\tHello World: [1, 2, 3]\n"
