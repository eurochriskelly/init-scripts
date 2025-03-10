#!/bin/bash

sourcePriv() {
  priv=$HOME/Workspace/repos/init-scripts/scripts/bash_common_private.sh
  if [ -f "$priv" ]; then
    source "$priv"
  else
    ls $HOME/Workspace/repos/init-scripts
    echo "Could not source private shared vars"
    exit 1
  fi
}
sourcePriv

ISPATH="$REPO_DIR/init-scripts"

export EDITOR=nvim

# make scripts executable
for file in "$ISPATH"/scripts/*; do
  if [[ "$file" == *~ ]]; then
    continue
  fi
  if [[ "$file" == */bash_common* ]]; then
    continue
  fi
  chmod +x "$file"
done

if [ -z "$(which screens)" ]; then
  export PATH="$PATH:${ISPATH}/scripts"
fi

# Loop over scripts starting with 'scr-' in the directory
find $ISPATH/scripts -name "*~" -exec rm {} \;
for scr in $ISPATH/scripts/scr-*; do
  if [ -f "$scr" ]; then
    source $scr
  else
    echo "Could not find script [$scr]"
  fi
done

showCKAliases() {
  # show a list of all aliases with a number and allow the user to select one
  # to run
  alias | grep "ck_" | awk '{print "  " $1}' | awk -F= '{print $1}' | cat -n
}

alias src='source $HOME/.zshrc'
alias last='ls -ltd */ | head -n 8'
alias ssh-mac='ssh -q $MACVM'
alias fuse-mac='sshfs $MACVM:/Users/${MACUSER}/Workspace ~/Workspace/mac'
if [ -n "$(which pbcopy)" ]; then
  alias pb='echo "">/tmp/pb;nvim /tmp/pb;cat /tmp/pb | pbcopy'
else
  alias pb='echo "">/tmp/pb;nvim /tmp/pb;cat /tmp/pb | xclip -selection clipboard'
fi
# TODO: better to maintain recent list and sort by frequency
alias j='jump $@'
alias arrows='xmodmap ~/.Xmodmap'

# easy to remember aliases for init scripts
alias screens="is-screens"
alias ds2="dirSizer 2"
alias ds3="dirSizer 3"
alias ds4="dirSizer 4"

git config --global alias.todo '!sh -c '\''t=$(git rev-parse --show-toplevel)/MYGIT_TODO.org; if [ -f "$t" ]; then echo "======== ========";cat "$t"; echo "======== ========"; fi'\'
git config --global alias.stat '!sh -c '\''t=$(git rev-parse --show-toplevel)/MYGIT_TODO.org; if [ -f "$t" ]; then echo "======== ========";cat "$t"; echo "======== ========"; fi; git status'\'
export RIPGREP_CONFIG_PATH=~/.ripgreprc
# Dependent on private vars
vimgolf() {
  # make sure challenge_id is set as $1
  if [ -z "$1" ]; then
    echo "Challenge ID not set"
    return 1
  fi
  if [ -z "$VIM_GOLF_KEY" ]; then
    echo "VIM_GOLF_KEY not set"
    return 1
  fi
  if [ -z "$(which docker)"]; then
    echo "Docker not installed"
    return 1
  fi
  echo "visit https://vimgolf.com to get key"
  docker run -it --rm -e "key=${VIM_GOLF_KEY}" ghrc.io/filbranden/vimgolf $1
}
sourcePriv

alias ck="cat $ISPATH/scripts/bash_common.sh|grep \"^alias\"|awk '{print $2}'| awk -F= '{print $1}'"
