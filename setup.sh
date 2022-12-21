#!/bin/bash
BEGIN_MARK="# sys-opt-tools begin {@"
END_MARK="# sys-opt-tools end @}"

MY_SELF=$(readlink -f "$0")
TOP_DIR=$(dirname $MY_SELF)

append_to_file() {
  filename="$1"
  echo "append to file $filename"
  env_file=$TOP_DIR/env.sh
  content="[ -f $env_file ] && . $env_file"
  echo "$BEGIN_MARK" >> $filename
  echo "$content" >> $filename
  echo "$END_MARK" >> $filename
}

print_effect() {
  cat <<EOF
Please " source $filename " to take effect
or open a new terminator
EOF
}

install() {
  echo "install start"
  RC_FILE=""
  if [ -n "$ZSH_VERSION" ];then
    RC_FILE=$(realpath ~/.zshrc)
  elif [ -n "$BASH_VERSION" ];then
    RC_FILE=$(realpath ~/.bashrc)
  else
    echo "unknown shell!!!"
    exit 1
  fi

  if [ -f $RC_FILE ];then
    sed -i "/$BEGIN_MARK/,/$END_MARK/d" $RC_FILE
    append_to_file $RC_FILE
    print_effect
  else
    echo "file not found: $RC_FILE"
  fi

  echo "install ok"
}

uninstall() {
  echo "uninstall start"
   RC_FILE=""
  if [ -n "$ZSH_VERSION" ];then
    RC_FILE=$(realpath ~/.zshrc)
  elif [ -n "$BASH_VERSION" ];then
    RC_FILE=$(realpath ~/.bashrc)
  else
    echo "unknown shell!!!"
    exit 1
  fi

  if [ -f $RC_FILE ];then
    sed -i "/$BEGIN_MARK/,/$END_MARK/d" $RC_FILE
  else
    echo "file not found: $RC_FILE"
  fi

  echo "uninstall ok"
}

print_usage() {
  cat <<EOF
  Usage: ./setup.sh [--uninstall]
EOF
}

main() {
  if [ $# -eq 0 ];then
    install
  elif [ "$1" = "--uninstall" ];then
    uninstall
  else
    print_usage
  fi
}

main "$@"
