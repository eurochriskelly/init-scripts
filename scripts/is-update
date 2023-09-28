#!/bin/bash
#
# Run from top-level using:
#
# `bash scripts/update.sh`
#
set -e

# update Xresources
echo "Updating xresources ..."
cp config/Xresources ~/.Xresources
cd ~
xrdb -merge .Xresources
cd -

# update emacs config
echo "Updating emacs ..."
test -d ~/.emacs.d || mkdir .emacs.d
test -f ~/.emacs && mv .emacs .emacs.$(date +%s)
cp -r apps/emacs/* ~/.emacs.d/

# update tmux
echo "Updating tmux ..."
cp apps/tmux/tmux.conf ~/.tmux.conf


