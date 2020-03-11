#!/bin/bash

set -e

if [ "$1" == "" ]
then
    echo "Usage: $0 FILENAME.MD [OUTPUT_DIR]"
    exit -1
fi

if [ "$2" == "" ]
then
    OUTDIR="."
else
    OUTDIR="$2"
fi

FILENAME=`grep -m1 value "$1" | cut -d'"' -f2`

mmark "$1" > "$OUTDIR"/"$FILENAME".xml

`which xml2rfc` -p "$OUTDIR" --html "$OUTDIR"/"$FILENAME".xml

exit 0
