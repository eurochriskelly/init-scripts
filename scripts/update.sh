#!/bin/bash
#
# Run from top-level using:
#
# `bash scripts/update.sh`
#
set -e

# update Xresources
cp config/Xresources ~/.Xresources
cd ~
xrdb -merge .Xresources
cd -

# update emacs config
test -d ~/.emacs.d || mkdir .emacs.d
test -f ~/.emacs && mv .emacs .emacs.$(date +%s)
cp -r apps/emacs/* .emacs.d/

# update tmux
cp apps/tmux/tmux.conf ~/.tmux.conf


