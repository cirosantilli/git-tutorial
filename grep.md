---
title: grep
social_media: true
permalink: git-tutorial/grep/
---


Search for lines in tracked files.

If you only want to search the entire current tree, `ack -a` is probably better as it has better formatted output.

There are however cases where `git grep` shines:

- it is crucial to ignore ignored files
- search in other revisions

Search for pattern `'a.c'` in all tracked files

    git grep 'a.c'

Limit search to files with the `.h` or `.hpp` extensions:

    git grep 'a.c' -- '*.h' '*.hpp'

Search in revision:

    git grep a.c 1.0

Search in revision only under directory:

    git grep a.c 1.0 -- dir

Show file names only:

    git grep -l a.c | xargs perl -lane 's/a/b/p'

## Configuration

Show line numbers by default:

    git config --global grep.lineNumber

Use extended regular expressions by default:

    git config --global grep.extendedRegexp
