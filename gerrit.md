---
title: Gerrit
social_media: true
permalink: git-tutorial/gerrit/
---

<https://www.gerritcodereview.com/>

What to do on each repo to use Gerrit with it...

    git config --local remote.origin.push HEAD:refs/for/master
    curl -Lo .git/hooks/commit-msg http://review.example.com/tools/hooks/commit-msg 
    git remote add ssh://<username>@gerrit-ring.savoirfairelinux.com:29420/ring-daemon
    git config --local push.draft.url :refs/drafts/master
    git config --local --add 'remote.origin.fetch +refs/changes/*:refs/remotes/origin/changes/*'

You must review every commit made before merging.

Anyone can make a pull request. Sign in with OAUTH, add an SSH key, and push there.

Created for Android. Still used? <https://android-review.googlesource.com/>

TODO browse source?!? Android uses GiTiles, so maybe not? <https://code.google.com/p/gitiles/> <https://android.googlesource.com/>

Docs explain well how this (shitty >:-)) software works:

-   <https://gerrit-documentation.storage.googleapis.com/Documentation/2.12/intro-quick.html>

    Pull requests are made by pushing to a magic branch name:

        git push origin HEAD:refs/for/master

    This is a win point over GitHub, whose pull requests duplicate info that should be in the commit message.

    You then want:

        git config --local remote.origin.push HEAD:refs/for/master

    to be able to do:

        git push

-   <https://gerrit-documentation.storage.googleapis.com/Documentation/2.12/user-changeid.html>

    GitHub branch "force pushes" are detected by a magic commit message line which says which commit was replaced.

    Yes, it makes our commits dirty.

    You can do that automatically with:

        curl -Lo .git/hooks/commit-msg http://review.example.com/tools/hooks/commit-msg 

    from inside the repo followed by:

        git commit --amend
        git push origin HEAD:refs/for/master

-   Reviewers fetch / checkout locally with:

        git fetch http://gerrithost:8080/p/RecipeBook refs/changes/68/2368/2
        git checkout -b FETCH_HEAD

    where:

    - `68` is the modulo 100 of the ID
    - `2368` is the ID, shown in the URL path as `/#/c/2636/`
    - `2` is the patch number (how many times it was force pushed - 1)

    You can get a good command from the "Download" dropdown at the top right corner.

    Note that since the remote ref is stored under a non-standard `refs/changes`, it does not create a branch `remotes/origin/something` by default.

    To fetch all changes on `git fetch` use:

        git config --local --add 'remote.origin.fetch +refs/changes/*:refs/remotes/origin/changes/*'

-   `/#/c/2538/6` means patchset 6 of change `2538`. `/#/c/2538` means the latest patch.

-   I think when you rebase and force push multiple commits, it updates the patch-set per commit

## Internals

    git clone https://gerrit.googlesource.com/gerrit

Official GitHub mirror: <https://github.com/gerrit-review/gerrit>

## Install Ubuntu

<http://stackoverflow.com/questions/10110247/how-to-install-gerrit-on-ubuntu-11-04/>

Official deployment seems to be through a `war` file download (standard, portable and annoying Java Server Pages deployment).

Non-official from gerritforge <https://www.linkedin.com/company/gerritforge-llp>, a Gerrit service company:

    echo 'deb mirror://mirrorlist.gerritforge.com/deb gerrit contrib' | sudo tee /etc/apt/sources.list.d/gerritforge.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1871F775
    sudo apt-get update
    sudo /etc/init.d/gerrit start
    firefox http://localhost:8080

Currently running 2.12.

You can create and switch to infinitely many accounts, including admin, without password, from the top left corner `Become` link.

## All diffs on the same page

On 2.12, when you hit `Open All`, it opens one diff file per new tab page... <https://code.google.com/p/gerrit/issues/detail?id=938>

## Related change

Shows all non-merged ancestors and descendants of the change. Very confusing, since they should be seen as a tree, but they are shown linearly instead.

## Same topic

TODO: this looks like Gerrit specific extra metadata that can be used to tag commits.

## Not current

This was force pushed, either updated or removed.

Gerrit knows that something was updated on a force push because of the `Change-Id` on the commit message.

To get the most recent one, change e.g. `Patch Sets (1/4)` to the latest `Patch Sets (4/4)`.

## Edit mode

You can edit changes in the browser! Amazing for a system that has no web-view.

<https://gerrit-review.googlesource.com/Documentation/user-inline-edit.html>

## Drafts

To back up changes that are not yet ready... use:

    git push origin HEAD:refs/drafts/master

or:

    git remote add draft ssh://<username>@gerrit-ring.savoirfairelinux.com:29420/ring-daemon
    git config --local push.draft.url :refs/drafts/master
    git push draft

The only thing this does is to hide the draft from everyone else. You can then explicitly allow individual people to see the draft.

## Publish review line comments

Even that is hard.

