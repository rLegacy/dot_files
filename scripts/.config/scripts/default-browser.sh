#!/usr/bin/bash

if [ "$DEFAULT_BROWSER" == "work" ]; then
    set -- "$@" -profile
    set -- "$@" /home/rlegacy/.mozilla/firefox/gburqjzk.work
fi

firefox "$@"
