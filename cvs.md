---
title: CVS
---

Welcome to hell.

Before anything, you need:

    export CVSROOT="$(pwd)"

## Get current commit

There is no commit for the entire repo, only for individual files!

The default for each file is to increase as:

    1.1
    1.2
    1.3

So the only way to specify your current repository state is to look for the latest revision.

A good bet is to look at the `ChangeLog` it hey maintain one...

    cvs log ChangeLog

## tag

List tags: <http://stackoverflow.com/questions/6174742/how-to-get-a-list-of-tags-created-in-cvs-repository>

Half impossible, since only individual files are tagged?
