#!/bin/bash
#
# Release a new version. This will perform the following actions:
# - Create a new git tag
# - Publish a new Github release
# - Deploy a newthe documentation on the gh-pages branch
# - Submit a PR on opam-repository

set -e

changes=$(git status --porcelain)
branch=$(git rev-parse --abbrev-ref HEAD)
version=$(sed -nE 's/^version: "(.*)"$/\1/p' inquire.opam)

if [ -n "${changes}" ]; then
  echo "Please commit staged files prior to bumping"
  exit 1
elif [ "${branch}" != "master" ]; then
  echo "Please run the release script on master"
  exit 1
else
  dune-release tag "v${version}" -y
  dune-release distrib
  dune-release publish -y
  dune-release opam submit --no-auto-open -y
fi
