#!/bin/bash

ldir="$HOME/.config/nvim/lua"
if [ -d "$ldir/snippets" ];then
  rm -rf $ldir/snippets
fi

cp -r @@REPO_DIR@@/apps/nvim/snippets $ldir/
cp @@REPO_DIR@@/apps/nvim/plugins/snippets.lua $ldir/plugins/
