#!/bin/bash

SPOONS=$(cd ../Spoons; git br | sed 's/^..//' | grep -v master | grep -v -- - | grep -v '/')
BRANCH=$(git symbolic-ref --short HEAD ^/dev/null)

for i in $SPOONS; do
    echo '### ' Updating $i ...
    (cd ../Spoons && \
         git co $i && \
         rsync -av Source/$i.spoon ../zzSpoons/Source
    )
done
git co $BRANCH
echo "Rebuilding zip files ..."
make all
echo "Rebuilding documentation ..."
./build_docs.sh
