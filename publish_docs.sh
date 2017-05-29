#!/bin/bash

rm -rf .newdocs && \
cp -a docs .newdocs && \
git co gh-pages && \
mv .newdocs/* . && \
rmdir .newdocs && \
git add . && \
git ci -a -m 'Updated docs' && \
git push

