---
title: hg
social_media: true
---

Most commands look like Git, we will focus on differences.

Decentralized.

## History

Also developed for the kernel after the BitKeeper incident, but Git won, and mercurial will fall into oblivion.

Written in Python. Should be much cleaner than Git. But harder to make a `libgit2` on top as well.

## update

`git checkout`:

    hg update -r revision

## ls-tree

## locate

    hg locate | grep path

## remote

## paths

Show remotes:

    hg paths

## branches

List all branches.

## tags

List all branches.

## purge

`git clean` <http://stackoverflow.com/questions/2760283/does-mercurial-have-an-equivalent-to-git-clean>

    hg purge

Also remove ignored files:

    hg purge --all

## Check current commit

<https://stackoverflow.com/questions/4330631/how-can-i-find-my-working-revision-in-mercurial>

    hg update something
    hg parents
