---
title: clone
social_media: true
permalink: git-tutorial/clone/
---

Make a "copy" of another repo.

Fetches all the remote branches.

Creates only a single branch: the branch were the `HEAD` of the remote was, but also fetches all other branches under `.git/refs/origin/`, so that you can just `git checkout -b other-branch` to create them.

## Example: clone and branches

Start with `multi`.

    git clone a c

Creates a repo `c` that is a "copy" of a. Now:

    cd c
    branch -a
        #master *
        #remote/origin/b
        #remote/origin/b2
        #remote/origin/master

So you only have one branch, and the other are remote heads.

But if you do:

    cd a
    git checkout b
    cd ..
    git clone a d
    cd d
    git branch -a
        #b *
        #origin/b
        #origin/b2
        #origin/master

Then you have a `b` branch, because that is where the head was when you cloned.

## Clone from GitHub

It can also clone from a server such as GitHub:

    git clone git@github.com:userid/reponame.git newname

This is how you download a project which interests you.

## depth

## Shallow clone

Clone only the `N` most recent commits and the working tree.

Has / had some limitations. But still, should only be used for CI and deployment.

Example:

    git clone https://github.com/jquery/jquery.git jquery
    git clone --depth 1 https://github.com/jquery/jquery.git jquery_shallow
    cd jquery_shallow
    git log

`jquery_shallow` is much smaller and the clone was much faster. But `git log` only shows the last commit for it.

For local clones, this can only be observed if you use `file://` as protocol: objects are just hardlinked otherwise if possible. `--no-hardlinks` changes nothing. <http://stackoverflow.com/questions/1992611/why-is-this-git-shallow-clone-bigger-than-i-expected>

    mkdir server
    cd server
    git init

    for i in a b c; do
        touch "$i"
        git add .
        git commit -m "$i"
    done

    cd ..
    git clone --depth 1 "file://$(pwd)/server" local
    cd local
    git log
