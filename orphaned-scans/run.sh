#!/usr/bin/env bash

find /home/rhefner/Dropbox/notebook/scans/ -name *.pdf -exec python find_orphaned_scans.py {} \;