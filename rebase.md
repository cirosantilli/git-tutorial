---
title: rebase
social_media: true
---

Change local history making it appear linear thus clearer.

As any history change, should only be done before pushing to a remote.

## Non-interactive rebase

Given:

    (A)----(B)----(C)
            |      |
            |      master *
            |
            +-----(D)
                   |
                   feature

If you do:

    git checkout feature
    git rebase master

you get:

    (A)----(B)----(C)-------(D2)
                   |         |
                   master    feature *

Therefore the rebase changes the history, making it look linear and therefore easier to understand.

This is how you should incorporate upstreams changes on your feature branch before you make a pull request, followed often by a squash interactive rebase.

## Interactive rebase

    git rebase -i HEAD~3

Opens up a Vim buffer where you can modify all commits between `HEAD` and `HEAD~2` (total 3 commits).

The buffer should contain something like this:

    pick fc95d59 last - 2 commit message
    pick 81961e9 last - 1 commit message
    pick d13a071 last commit message

    # Rebase d57a363..d13a071 onto d57a363
    #
    # Commands:
    #  p, pick = use commit
    #  r, reword = use commit, but edit the commit message
    #  e, edit = use commit, but stop for amending
    #  s, squash = use commit, but meld into previous commit
    #  f, fixup = like "squash", but discard this commit's log message
    #  x, exec = run command (the rest of the line) using shell
    #
    # These lines can be re-ordered; they are executed from top to bottom.
    #
    # If you remove a line here THAT COMMIT WILL BE LOST.
    #
    # However, if you remove everything, the rebase will be aborted.
    #
    # Note that empty commits are commented out

### Edit

`edit` can be used for example if we want to change the commit message for `HEAD~` we edit that to:

    pick fc95d59 last - 2 commit message
    edit 81961e9 last - 1 commit message
    pick d13a071 last commit message

Save and quit.

Now git puts us back as `HEAD~1`.

We can then:

    git commit --amend -m 'new last - 1 commit message'

When you are satisfied:

    git rebase --continue

If you change your mind and think that it is better not to rebase do:

    git rebase --abort

If you change your mind only about a single `commit`, but still want to change the others to:

    git rebase --skip

And we are back to `HEAD`.

Now `git log --pretty=oneline -n3` gives:

    fc95d59[...] last - 2 commit message
    81961e9[...] new last - 1 commit message
    d13a071[...] last commit message

### squash

`squash` can be used if you want to remove all trace of a commit.

`squash` is useful when you are developing a feature locally and you want to save progress at several points in case you want to go back.

When you are done, you can expose a single commit for the feature, which will be much more concise and useful to others, or at least people will know that you can use `squash`.

You will also look much smarter, since it will seem that you did not make lots of trials before getting things right.

If we want to remove only the `HEAD~` from history we edit as:

    pick fc95d59 last - 2 commit message
    s 81961e9 last - 1 commit message
    pick d13a071 last commit message

This will open up another Vim buffer like:

    # This is a combination of 2 commits.
    # The first commit's message is:

    last -2 commit message

    # This is the 2nd commit message:

    last -1 commit message

    #[more comments]

Because commits `HEAD~` and `HEAD~2` will be turned into one, it is likely that the new message will be neither of the two.

So, erase all non comment lines and do something like:

    last -1 and last -2 together
    #[more comments]

Now `git log --pretty=oneline -n2` gives something like:

    fc95d59[...] last -1 and last -2 together
    d13a071[...] last commit message

It is not possible to squash the last commit of a rebase:

    squash fc95d59 last - 2 commit message
    pick 81961e9 last - 1 commit message
    pick d13a071 last commit message

To do that, it would be necessary to do a `git rabase -i HEAD~4`, and `pick` `HEAD~4`:

    pick fc95d59 last - 2 commit message
    squash fc95d59 last - 2 commit message
    pick 81961e9 last - 1 commit message
    pick d13a071 last commit message

### reorder and delete

It is also possible to reorder and erase any commit on the commit list.

All you need to do is to change the line order or remove lines.

## Internals

TODO What does rebase do exactly? I think it was a series of merges like this:

    A---B---C---D---E (master)
        |
        F---G (HEAD)

Let:

    new_comit = merge(base, commit1, commit2)

be the basic 3-way merge operation, where:

- `base` must be is an ancestor of both `commit1` and `commit2`
- `new_commit` is always a child of `commit1` and `commit2`

Then:

    rebase master

First advances `F` over `C`:

    A---B---C---D---E (master)
        |   |
        |   +---F2
        |       |
        F-------+
        |
        +---G (HEAD)

where:

    F2 = merge(B, F, C)

Note that `C` and `F` are parents of `F2`.

Next `G` is advanced over `F2`:

    A---B---C---D----E (master)
        |   |
        |   +---F2---G2 (HEAD)
        |       |    |
        F-------+    |
        |            |
        +---G--------+

where:

    G2 = merge(F, F2, G)

Now we can just throw away the old `F` and `G`:

    A---B---C---D----E (master)
            |
            +---F2---G2 (HEAD)

and it is clear that we have advanced one step!

Now we just repeat until advancing over `E` to reach:

    A---B---C---D----E---F4---G4
