---
title: fetch
social_media: true
permalink: git-tutorial/fetch/
---

Looks for changes made on a remote repository and brings them in.

The full signature is:

    git fetch <remote> <refspec>

where `<refspec>` is the same as for `git push`.

You can do a dry run that only lists remote references with `ls-remote`.

For example, to update you `master` branch from a remote `dev` you can do:

    git fetch origin dev:master

This will only work for fast-forward changes, because it could be done for any branch, not just the current one, and in that case there is no way to resolve merge conflicts without a working tree.

## Omit refspec

Omitting refspec as in:

    git fetch <remote>

defaults `<refspec>` to:

-   `remote.<remote>.fetch`, which is set by default on remote creation to `+refs/heads/*:refs/remotes/<remote>/*` configuration, so a matching forced update from remote `heads` into local `remotes/<remote>/`.

    So after you `git fetch origin`, you can create a local branch with a shorter name and checkout to it with:

        git checkout -b local-name origin/remote-branch

    Remember that this works because `.refs/remotes` is in the refs search path, and no sane person would have a local reference called `.git/heads/origin/remote-branch`, or that would have the preference.

    Multiple `remote.<remote>.fetch` entries can be added. A possibly useful one with GitHub, is:

        fetch = +refs/pull/*/head:refs/pull/origin/*

    which also fetches all pull requests, which GitHub stores under `refs/pulls`. You can then checkout with:

        git checkout -b 999 pull/origin/999

    Remember that just `origin/999` won't work because `refs/pulls` is not in the refs search path.

    Also note that this configuration would might pull *a lot* of references, so you might be better off with one off commands like:

        git fetch origin pull/<pr-number>/head:local-name

-   `origin`

This hasn't changed in Git 2.0, and is therefore simpler than the default refspec for `git push`.

## Omit remote

Defaults the remote to the first defined of:

- `branch.<name>.remote`
- `origin`

## FETCH_HEAD

A reference that points to the latest fetched branch.

Common use case: get a single commit not on the main repository, often on the fork feature branch of a pull request, to try it out locally without merging or adding a new remote:

    git fetch origin pull/<pr-number>/head
    git checkout -b <local-branch-name> FETCH_HEAD
