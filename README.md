# rhefner1/notebook-utils
I keep my notebook as a folder of Markdown files in a directory on my computer synced to Dropbox. To keep track of my thought process throughout the day, I want to have a Git commit in the notebook at the end of each day.

## Versioner
Here's what the `notebook_versioner.sh` script does:
- Starts the Dropbox daemon to sync the latest notebook files
- Creates a new commit and pushes to GitHub
- Waits for the new files to sync back to Dropbox
- Shuts down

## Orphaned Scans
`orphaned-scans/run.sh` looks through the `scans/` and `archive/scans/` directories and finds scans that aren't referenced in any other notes.
