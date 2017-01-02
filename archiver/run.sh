#!/usr/bin/env bash

cd ~/Dropbox/notebook/journal

# Fix links to other documents
ls -t .. | grep -v scans | tr '\n' '|' | head -c -1 | grep -PRoh "\.\.\/($(cat -))" | uniq | sed 's#\.#\\\.#g' | while read -r line; do sed -i "s#$line#\.\./$line#g" *.md; done

# Move linked scans to archive/scans
grep -PRoh "\.\.\/scans\/(.*?)\.pdf" | while read -r line; do mv "$line" ../archive/scans; done

# Move all files to archive/journal
mv ./*.md ../archive/journal/
