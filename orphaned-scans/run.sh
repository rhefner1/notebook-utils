#!/usr/bin/env bash

find /home/rhefner/Dropbox/notebook/scans/ -name *.pdf | xargs -d '\n' python find_orphaned_scans.py
find /home/rhefner/Dropbox/notebook/archive/scans/ -name *.pdf | xargs -d '\n' python find_orphaned_scans.py

