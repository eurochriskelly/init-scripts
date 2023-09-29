#!/bin/bash

priv=~/Workspace/repos/init-scripts/scripts/bash_common_private.sh
if [ -f "$priv" ];then
    source "$priv"
else
    ls ~/Workspace/repos/init-scripts/S
    echo "Could not source private shared vars"
    exit 1
fi

ISPATH="$REPO_DIR/init-scripts"
export EDITOR=emacs

for file in "$ISPATH"/scripts/*; do
    if [[ "$file" == *~ ]]; then
	continue
    fi
    if [[ "$file" == */bash_common* ]]; then
	continue
    fi
    chmod +x "$file"
done

if [ -z "$(which screens)" ];then
    export PATH="$PATH:${ISPATH}/scripts"
fi

# Source commands
for scr in scr-jump;do
    if [ -f "$ISPATH"/scripts/"$scr" ];then
	echo "sourcing path $scr"
	source $ISPATH/scripts/$scr
    else
	echo "Could not find script [$scr]"
    fi
done

alias src='source ~/.bashrc'
alias ssh-mac='ssh -q $MACVM'
alias fuse-mac='sshfs $MACVM:/Users/${MACUSER}/Workspace ~/Workspace/mac'
alias pb='echo "">/tmp/pb;et /tmp/pb;cat /tmp/pb | xclip -selection clipboard'
alias et='emacsClientHereText'
alias etg='emacsClientHereGui'
# TODO: better to maintain recent list and sort by frequency
alias be='emacs-snapshot ~/.bashrc'
alias j='jump'
alias e='quickEdit'

# easy to remember aliases for init scripts
alias screens="is-screens"


alias aaa="cat $ISPATH/scripts/bash_common.sh|grep \"^alias\"|awk '{print $2}'| awk -F= '{print $1}'"
echo "Run 'aaa' to see aliases"
