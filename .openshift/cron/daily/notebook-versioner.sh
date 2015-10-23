#!/usr/bin/env bash

cd $OPENSHIFT_TMP_DIR

echo "Downloading notebook..."
wget $NOTEBOOK_DROPBOX_LINK -O ./notebook.zip

echo "Download complete. Unzipping..."
mkdir ./notebook
unzip notebook.zip -d ./notebook

# Need to do manual lowercasing/merging of directories because Linux filesystem
# is case-sensitive but Dropbox's isn't. The .zip file above, for example, has
# half of the files in ./general and the other half in ./General. Not good.
for i in $(find ./notebook -maxdepth 1 -path .git -prune -o -type d -name "*[A-Z]*");
do
  cp -R "$i"/* "$(echo $i | tr A-Z a-z)";
  rm -rf "$i";
done

for i in $(find ./notebook/school -maxdepth 1 -path .git -prune -o -type d -name "*[A-Z]*");
do
  cp -R "$i"/* "$(echo $i | tr A-Z a-z)";
  rm -rf "$i";
done

echo "Commiting and pushing..."
cd ./notebook
git config core.fileMode false
git add --all
git commit -m $(date +'%Y-%m-%d')
git push -f origin master

cd $OPENSHIFT_TMP_DIR
rm -rf notebook
rm -f notebook.zip
