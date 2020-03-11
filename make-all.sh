#!/bin/bash

set -e

if [ "$1" == "" ]
then
    OUTDIR='build'
else
    OUTDIR="$1"
fi
TMPDIR='/tmp/makedown2rfc-make-all-git'

while read repository fileglobs; do
    basename=$(basename -- "$repository")
    reponame="${basename%.*}"
    echo ">----------"
    echo ">Making $repository"
    echo "> target directory: $reponame"
    echo "> file globs: $fileglobs"

    gitdir="$TMPDIR"/"$reponame"
    if [ -e "$gitdir" ]
    then
        echo "> pulling latest changes"
        mkdir -p "$TMPDIR"
        git -C "$gitdir" checkout --quiet master
        git -C "$gitdir" fetch --quiet --all
        git -C "$gitdir" pull --quiet
    else
        echo "> cloning repository"
        git -C "$TMPDIR" clone --quiet "$repository" "$reponame"
    fi

    outdirbase="$OUTDIR"/"$reponame"
    for ref in $(git -C "$gitdir" for-each-ref --format='%(refname:short)' | grep 'origin/')
    do
        echo "> on branch $ref"
        git -C "$gitdir" checkout --quiet "$ref"
        htmloutputdir="$outdirbase"/"${ref#origin/}"
        errordir="$htmloutputdir"/errors
        mkdir -p "$htmloutputdir"
        mkdir -p "$errordir"

        for fileglob in $fileglobs
        do
            if ! compgen -G "$gitdir"/$fileglob > /dev/null
            then
                echo "> no files for $fileglob"
            else
            for file in "$gitdir"/$fileglob
            do
                echo "> making $file"
                errorfile="$errordir"/$(basename -- "$file").txt
                rm "$errordir" 2> /dev/null || true
                ./make.sh "$file" "$htmloutputdir" 2> "$errorfile" || echo "> error processing $file, see $errorfile"
            done
            fi
        done
    done
done < repositories.txt
