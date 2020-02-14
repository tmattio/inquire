#!/bin/bash
# Usage: script/release.sh
#
# Push a new git tag on the remote repository with the version found in dune-project

set -e

changes=$(git status --porcelain)
branch=$(git rev-parse --abbrev-ref HEAD)

if [ -n "${changes}" ]; then
  echo "Please commit staged files prior to bumping"
  exit 1
elif [ "${branch}" != "master" ]; then
  echo "Please run the release script on master"
  exit 1
else
  VERSION=$(sed -nE 's/^version: "(.*)"$/\1/p' inquire.opam)
  dune-release tag v$VERSION -y
  dune-release distrib
  dune-release publish -y
  dune-release opam submit --no-auto-open -y
fi
