#!/bin/bash

priv=$HOME/Workspace/repos/init-scripts/scripts/bash_common_private.sh
if [ -f "$priv" ]; then
    echo "Sourcing private bash"
    source "$priv"
else
    ls $HOME/Workspace/repos/init-scripts
    echo "Could not source private shared vars"
    exit 1
fi

ISPATH="$REPO_DIR/init-scripts"

export EDITOR=emacs

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

# Source commands
find $ISPATH/scripts -name "*~" -exec rm {} \;
for scr in $ISPATH/scripts/scr-*; do
    if [ -f "$scr" ]; then
        echo "Sourcing path $scr"
        source $scr
    else
        echo "Could not find script [$scr]"
    fi
done

alias src='source $HOME/.zshrc'
alias ssh-mac='ssh -q $MACVM'
alias fuse-mac='sshfs $MACVM:/Users/${MACUSER}/Workspace ~/Workspace/mac'
if [ -n "$(which pbcopy)" ];then
    alias pb='echo "">/tmp/pb;et /tmp/pb;cat /tmp/pb | pbcopy'
else
    alias pb='echo "">/tmp/pb;et /tmp/pb;cat /tmp/pb | xclip -selection clipboard'
fi
alias et='emacsClientHereText'
alias etg='emacsClientHereGui'
# TODO: better to maintain recent list and sort by frequency
alias be='emacs-snapshot $HOME/.bashrc'
alias j='jump'
alias e='quickEdit'

# easy to remember aliases for init scripts
alias screens="is-screens"
alias ds2="dirSizer 2"
alias ds3="dirSizer 3"
alias ds4="dirSizer 4"

alias aaa="cat $ISPATH/scripts/bash_common.sh|grep \"^alias\"|awk '{print $2}'| awk -F= '{print $1}'"
echo "Run 'aaa' to see aliases"
