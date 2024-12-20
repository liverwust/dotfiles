#!/bin/bash
#

MY_PATH=`dirname "$0"`
test -d "${MY_PATH}/.git" || exit 1
test -f "${MY_PATH}/reset-submodules.sh" || exit 1
rm -rf "${MY_PATH}/.git/modules/"*
rm -rf "${MY_PATH}/vim-"*
rm -rf "${MY_PATH}/restricted-submodules/vim-"*
rm -rf "${MY_PATH}/ansible-vim"
rm -rf "${MY_PATH}/tlib_vim"
