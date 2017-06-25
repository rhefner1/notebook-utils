#!/usr/bin/env bash

wait_for_dropbox() {
  echo "Starting dropboxd"
  dropbox start

  echo "Waiting for Dropbox to sync..."
  i=0
  while [ "$(dropbox status)" != 'Up to date' ]
  do
    let i+=1
    if [ "$i" -ge 900 ]
      then
        echo "Dropbox timed out. Exiting..."
        exit 1
    fi
    sleep 2;

  done
  dropbox stop
}

echo "Starting notebook versioner."

# Making sure we have the right timezone
sudo timedatectl set-timezone Europe/Prague

# And saving the variable earlier in the script so we don't
# cross over into the next day before Dropbox is finished syncing
DATE="$(date -d "yesterday" +'%Y-%m-%d')"

# Wait until Dropbox is finished syncing before doing the commit
wait_for_dropbox

cd ~/Dropbox/notebook

# Converting all tabs to spaces
find . -name '*.md' ! -type d -exec bash -c 'expand -t 4 "$0" > /tmp/e && mv /tmp/e "$0"' {} \;

# Trimming whitespace from files
find . -type f -name '*.md' -exec sed --in-place 's/[[:space:]]\+$//' {} \+

# Add newlines if they don't exist
find . -type f -name '*.md' -exec sed -i -e '$a\' {} \+

echo "Commiting and pushing..."
git config core.fileMode false
git add --all
git commit -m ${DATE} --author "Ryan Hefner <rhefner1@gmail.com>"
git push origin master

# Wait until Dropbox is finished syncing before finishing
wait_for_dropbox
