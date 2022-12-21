#!/usr/bin/bash
MY_SELF=$(readlink -f $0)
ROOT_DIR=$(dirname $MY_SELF)
export PATH=$ROOT_DIR/bin:$PATH
