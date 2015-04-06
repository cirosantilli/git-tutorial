---
title: How Git rebase works
social_media: true
---

Just speculating.

## Merge refresher

Git rebase does a bunch or merges.

A 3-way merge is an operation that takes 3 commits as input: `master`, `feature` and `base`.

The output is a new merged commit which is a children `feature` and `base`.

So, if we just discard one of the comments, we are able to make the commits move along the `master`.

## Single commit on the feature

Initial state:

    (1)-----(2)-----(3)
     |               |
     |               master
     |
     +------(4)
             |
             feature

You then do:

    git checkout feature
    git rebase master

Git first finds a most recent ancestor: `(1)`.

To move the `feature` branch ahead, Git does a merge with:

- `master` = `(2)`, the first step of the rebase
- `feature` = `(4)`, what we are going to rebase with
- `base` = `(1)`, the most recent ancestor.

After the merge, this generates a new temporary commit `(5)` with two parents `(2)`, `(4)`.

    (1)-----(2)-----(3)
     |       |       |
     |       |       master
     |       |
     |       +-------+
     |               |
     +------(4)-----(5)
                     |
                     feature

Then if we just ignore the old commit `(4)`, we get:

    (1)-----(2)-----(3)
             |       |
             |       master
             |
             +-------+
                     |
                    (5)
                     |
                     feature

If is as if the feature moved one commit forward!

Repeat again and we get:

    (1)-----(2)-----(3)-----(6)
                     |       |
                     master  feature

## Multiple commits on the feature

TODO
