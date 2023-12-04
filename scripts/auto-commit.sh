#!/bin/bash

#
# In your ~/.crontab place the following:
# 0 0 * * * /path/to/scripts/auto-commit.sh
#

top=$(git rev-parse --show-toplevel)

touch /tmp/auto-commit log

cd $top

echo "Committing files from [$(pwd)] and pushing"
git stash
git pull
git stash pop
git add .
git commit -m "Daily automated commit on $(date)"
git push origin main

