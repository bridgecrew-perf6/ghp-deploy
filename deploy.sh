#!/bin/bash

TMP_DEPLOY_PATH=/tmp/ghp-deploy
DEPLOY_BRANCH=deploy

# generate static pages
python generate_pages.py

# make temporary directory for copying content
rm -rf $TMP_DEPLOY_PATH && mkdir -p $TMP_DEPLOY_PATH

# copy content into temporary directory
cp -R output/* $TMP_DEPLOY_PATH

# copy last commit message
COMMIT=$(git log -1 --format=%s)

# switch to deploy branch
git fetch origin $DEPLOY_BRANCH
if [[ $(git rev-parse --verify --quiet $DEPLOY_BRANCH) ]];
then
    # branch already exists: switch to branch then clear tracked files
    git switch $DEPLOY_BRANCH && git ls-tree -r --name-only test_branch | xargs rm -f
else
    # branch does not exist: create empty branch
    git switch --orphan $DEPLOY_BRANCH
fi

# copy content into root directory
cp -R $TMP_DEPLOY_PATH/* .
# add all static pages to deploy branch
git ls-files --others --exclude-standard -- ':(exclude)output/*' | grep '.*\.html$' | xargs git add
git commit -m "$COMMIT"
git push -f --set-upstream origin $DEPLOY_BRANCH
git switch main