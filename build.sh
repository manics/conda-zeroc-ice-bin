#!/bin/bash

set -eux

env | sort
# zeroc-ice ignores $AR
ln -s $AR $(dirname $AR)/ar

make -C mcpp
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

make -C cpp -j$CPU_COUNT

make -C cpp prefix=$PREFIX install

# Move some directories into share
rm -rf $PREFIX/config/__pycache__/
mkdir -p $PREFIX/share/zeroc-ice
mv $PREFIX/config/* $PREFIX/slice $PREFIX/share/zeroc-ice/
rmdir $PREFIX/config

# slice2py is in the Python package
rm $PREFIX/bin/slice2py
