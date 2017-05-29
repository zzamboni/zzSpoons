#!/bin/bash

mkdir -p .docs_tmp
./scripts/bin/build_docs.py -e ./scripts/templates/ -o .docs_tmp -i "Hammerspoon zzSpoons" -j -t -n Source
cp ./scripts/templates/{docs.css,jquery.js} .docs_tmp/html/
mv .docs_tmp/html/* docs/
mv .docs_tmp/docs{,_index}.json docs/
