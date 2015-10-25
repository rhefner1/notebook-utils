# Creating the Worker VM Image

1. Change to root directory: `cd /root`
2. Set up Dropbox
  - Download: `cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -`
  - Run the daemon: `./dropbox-dist/dropboxd`
  - Copy the link into a browser and exit out of the daemon
  - Download the CLI interface: `wget -O ./dropbox.py "https://www.dropbox.com/download?dl=packages/dropbox.py" && chmod +x ./dropbox.py`
  - Run to ignore other folders: `./dropbox.py exclude add ~/Dropbox/apps ~/Dropbox/docs ~/Dropbox/git ~/Dropbox/music ~/Dropbox/photos ~/Dropbox/Public ~/Dropbox/school`
3. Install necessary packages: `yum install git wget`
4. Copy the notebook versioner bash script (on host): `scp ./notebook_versioner.sh [ip]:~`
5. Move the script: `mv /home/rhefner/notebook_versioner.sh /root && chmod +x /root/notebook_versioner.sh`
6. Create ssh keypair: `ssh-keygen` (and add that to GitHub)
7. Try out the script to make sure it works! As long as the VM runs `/root/notebook_versioner.sh`, Dropbox will automatically be started, synced and the notebook changes will be pushed.
