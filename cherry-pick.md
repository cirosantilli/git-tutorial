---
title: cherry-pick
social_media: true
---

Merge change introduced by given commits.

If merge is not clean, may create merge conflicts which you have to resolve similarly to `git merge`.

The existing merge messages and other metadata are kept.

Merge only the last commit from the `other-branch` branch:

    git cherry-pick other-branch

Almost like taking a patch and applying: <http://stackoverflow.com/questions/5156459/what-are-the-differences-between-git-cherry-pick-and-git-show-patch-p1>

May lead to more conflicts as you lose the ancestor information.
