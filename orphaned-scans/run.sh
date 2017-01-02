#!/usr/bin/env bash

find /home/rhefner/Dropbox/notebook/assets/ -name *.pdf | xargs -d '\n' python find_orphaned_scans.py
find /home/rhefner/Dropbox/notebook/archive/assets/ -name *.pdf | xargs -d '\n' python find_orphaned_scans.py

