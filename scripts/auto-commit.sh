#!/bin/bash

#
# In your ~/.crontab place the following:
# 0 0 * * * /path/to/scripts/auto-commit.sh /path/to/repo > /tmp/log123 2>&1
#

cd $1

echo "Committing files from [$(pwd)] and pushing"
git stash
git pull
git stash pop
git add .
git commit -m "Daily automated commit on $(date)"
git push origin main
echo "Auto-commit complete"

