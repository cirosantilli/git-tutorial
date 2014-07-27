#!/usr/bin/env bash

# This script is meant to be put on the same dir as the test repos.

set -eu

F="$(basename "$0")"
usage() {
  echo "Copy and remove the standard git test repos.

Makes it faster to make new tests without modifying existing test templates.

# Examples

Copy dir '1' as dir 't' and 'cd' into it:

    ./$F 1

Remove current dir 't' and copy dir 'multi' as 't':

    ./$F multi
" 1>&2
}

if [ $# -eq 1 ]; then
  R="$1"
else
  usage
  exit 1
fi

rm -rf t
cp -r $R t
cd t
exec bash
