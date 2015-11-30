# Notebook Versioner
I keep my notebook as a folder of Markdown files in a directory on my computer synced to Dropbox. To keep track of my thought process throughout the day, I want to have a Git commit in the notebook at the end of each day.

This app pulls down latest notebook files via Dropbox, performs a Git commit and pushes up to the notebook repo.

Here's the flow of the application:

1. Google App Engine's cron service sends a web request at the end of each day.
2. A web handler on App Engine (**controller**) receives the request and sends an API call to spin up a Google Compute Engine virtual machine. It also schedules the termination of the instance 1 hour later.
3. The Compute Engine VM is passed a startup script to do the following:
  - Starts the Dropbox daemon to sync the latest notebook files
  - Creates a new commit and pushes to GitHub
  - Waits for the new files to sync back to Dropbox
  - Shuts down
4. App Engine gets a notification from the task queue to terminate the virtual machine. While it has been powered down since the script finished running, GCE still charges a small amount for keeping the persistent disks around. We need to terminate the instance to avoid that cost.

## Creating the Worker VM Image

1. Change to root directory: `cd /root`
2. Set up Dropbox
  - Download: `cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -`
  - Run the daemon: `./dropbox-dist/dropboxd`
  - Copy the link into a browser and exit out of the daemon
  - Download the CLI interface: `wget -O ./dropbox.py "https://www.dropbox.com/download?dl=packages/dropbox.py" && chmod +x ./dropbox.py`
  - Run to ignore other folders: `./dropbox.py exclude add ~/Dropbox/apps ~/Dropbox/docs ~/Dropbox/git ~/Dropbox/music ~/Dropbox/photos ~/Dropbox/Public ~/Dropbox/school`
3. Install necessary packages: `yum install git wget`
4. Create ssh keypair: `ssh-keygen` (and add that to GitHub)
5. Try out the script to make sure it works! As long as the `notebook_versioner.sh` is passed to the VM as the startup script, Dropbox will automatically be started, synced and the notebook changes will be pushed.
