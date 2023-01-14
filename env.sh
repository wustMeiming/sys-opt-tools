#!/usr/bin/bash
MY_SELF=$(readlink -f $0)
ROOT_DIR=$(dirname $MY_SELF)

# bin目录加入环境变量
export PATH=$ROOT_DIR/bin:$PATH

# 加载别名文件
[ -f $ROOT_DIR/.alias ] && source $ROOT_DIR/.alias
