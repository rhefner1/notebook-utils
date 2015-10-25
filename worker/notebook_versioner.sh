#!/usr/bin/env bash

wait_for_dropbox() {
  echo "Waiting for Dropbox to sync..."
  i=0
  while [ "$(/root/dropbox.py status)" != 'Up to date' ]
  do
    let i+=1
    if [ "$i" -ge 150 ]
      then
        echo "Dropbox timed out. Exiting..."
        exit 1
    fi
    sleep 2;

  done
}

echo "Starting notebook versioner."

echo "Starting dropboxd"
/root/dropbox.py start

# Wait until Dropbox is finished syncing before doing the commit
wait_for_dropbox

echo "Commiting and pushing..."
cd /root/Dropbox/notebook
git config core.fileMode false
git add --all
git commit -m $(date +'%Y-%m-%d') --author "Ryan Hefner <rhefner1@gmail.com>"
git push -f origin master

# Wait until Dropbox is finished syncing before finishing
wait_for_dropbox

shutdown -h now
