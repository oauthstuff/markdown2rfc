#!/bin/bash

set -e

if [ "$1" == "" ]
then
    echo "Usage: $0 FILENAME.MD"
    exit -1
fi

FILENAME=`grep -m1 value "$1" | cut -d'"' -f2`

mmark "$1" > "$FILENAME".xml

`which xml2rfc` --html "$FILENAME".xml
