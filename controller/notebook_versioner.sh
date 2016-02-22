#!/usr/bin/env bash

wait_for_dropbox() {
  echo "Starting dropboxd"
  /root/dropbox.py start

  echo "Waiting for Dropbox to sync..."
  i=0
  while [ "$(/root/dropbox.py status)" != 'Up to date' ]
  do
    let i+=1
    if [ "$i" -ge 900 ]
      then
        echo "Dropbox timed out. Exiting..."
        exit 1
    fi
    sleep 2;

  done

  echo "Stopping dropboxd"
  /root/dropbox.py stop
}

echo "Starting notebook versioner."

# Making sure we have the right timezone
cp /usr/share/zoneinfo/America/New_York /etc/localtime

# And saving the variable earlier in the script so we don't
# cross over into the next day before Dropbox is finished syncing
DATE="$(date -d "yesterday" +'%Y-%m-%d')"

# Wait until Dropbox is finished syncing before doing the commit
wait_for_dropbox

cd /root/Dropbox/notebook

# Converting all tabs to spaces
find . -name '*.md' ! -type d -exec bash -c 'expand -t 2 "$0" > /tmp/e && mv /tmp/e "$0"' {} \;

# Trimming whitespace from files
find . -type f -name '*.md' -exec sed --in-place 's/[[:space:]]\+$//' {} \+

echo "Commiting and pushing..."
git config core.fileMode false
git add --all
git commit -m ${DATE} --author "Ryan Hefner <rhefner1@gmail.com>"
git push origin master

# Wait until Dropbox is finished syncing before finishing
wait_for_dropbox

shutdown -h now
