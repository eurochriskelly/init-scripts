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

alias src='source ~/.bashrc'
alias ssh-mac='ssh -q $MACVM'
alias fuse-mac='sshfs $MACVM:/Users/${MACUSER}/Workspace ~/Workspace/mac'
alias go:repos='cd $REPO_DIR'
alias pb='echo "">/tmp/pb;et /tmp/pb;cat /tmp/pb | xclip -selection clipboard'
alias et='emacsclient-snapshot -t $1'
alias etg='emacsclient-snapshot -c $1'
alias be='emacs-snapshot ~/.bashrc'

# easy to remember aliases for init scripts
alias screens="is-screens"

alias aaa="cat $ISPATH/scripts/bash_common.sh|grep \"^alias\"|awk '{print $2}'| awk -F= '{print $1}'"
echo "Run 'aaa' to see aliases"
