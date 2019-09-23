#!/bin/bash

FILENAME=`grep seriesInfo main.md -A 10 | grep value -m 1 | cut -d'"' -f2`

mmark -2 main.md > $FILENAME.xml
`which xml2rfc` --legacy --html $FILENAME.xml
`which xml2rfc` --legacy --text $FILENAME.xml

