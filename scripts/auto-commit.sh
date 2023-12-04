#!/bin/bash

#
# In your ~/.crontab place the following:
# 0 0 * * * /path/to/scripts/auto-commit.sh
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR
top=$(git rev-parse --show-toplevel)
cd $top

echo "Committing files from [$(pwd)] and pushing"
git stash
git pull
git stash pop
git add .
git commit -m "Daily automated commit on $(date)"
git push origin main
echo "Auto-commit complete"

