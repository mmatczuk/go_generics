#!/usr/bin/env bash

set -eu

TEMP_DIR=`mktemp -d`

git clone git@github.com:google/gvisor.git "${TEMP_DIR}"
git -C "${TEMP_DIR}" filter-branch --prune-empty --subdirectory-filter tools/go_generics
git remote add gvisor "${TEMP_DIR}/.git"
git fetch gvisor
