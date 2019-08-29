#!/bin/bash

set -eux

env | sort
# zeroc-ice ignores $AR
ln -s $AR $(dirname $AR)/ar
ar --version

# https://github.com/zeroc-ice/ice/blob/v3.6.5/.travis.yml
git clone -b v2.7.2.14 https://github.com/zeroc-ice/mcpp.git mcpp
make -C mcpp
cp mcpp/lib/*/* mcpp/lib/
export MCPP_HOME=$PWD/mcpp

export GCC_COMPILER=yes
export OPTIMIZE=yes

# PREFIX is set by conda build

BZIP2_HOME=$PREFIX
DB_HOME=$PREFIX
EXPAT_HOME=$PREFIX
OPENSSL_HOME=$PREFIX
ICONV_HOME=$PREFIX
READLINE_HOME=$PREFIX

export BZIP2_HOME DB_HOME EXPAT_HOME OPENSSL_HOME ICONV_HOME READLINE_HOME

# TODO: is this needed?
MAKE_ARGS="embedded_runpath=no LP64=yes"
make $MAKE_ARGS -j$CPU_COUNT

make prefix=$PREFIX install

# This isn't a correct Python module so remove from final package
rm -rf $PREFIX/python
