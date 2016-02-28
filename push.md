---
title: push
social_media: true
permalink: git-tutorial/push/
---

Makes changes on a bare remote repo.

The other repo can be on an external server like GitHub, or on your local filesystem.

Typical changes possible with push:

- put branches there
- remove branches from there

The full form of the command is:

    git push <remote> +<src>:<dst>

As a concrete example:

    git push origin +master:dev

but there are (sensible) defaults for almost every part of the command, many of which are controlled by options. Also, there were major configuration and documentation updates on 2.0, So brace yourself!

The full form, pushes the local branch `<src>` to remote with the name `<dst>`. If `<dst>` does not exist it is created.

The plus sign `+` is optional the same as `-f`: if given allows non-fast-forward updates, thus allowing you to lose commits on the remote.

## dst

You can push anywhere under `refs/` you want.

- `master` means `refs/heads/master`
- `refs/tags/1.0`
- `refs/custom/a`

## Omit dst

    git push <remote> <src>

is the same as:

    git push <remote> <src>:<src>

## Omit src

    git push <remote> :<dst>

deletes the branch `master` on the remote. The mnemonic is `<src>` does not exist, so you replace the remote with nothing.

Later versions of git added the saner `--delete` option which does the same thing:

    git push --delete <remote> <dst>

## Omit src and dst

    git push <remote> :

Does a matching push: pushes all branches which track on `<remote>` for which a branch with the same name exists on `<remote>`.

## refspec

The name of the `+local-name:remote-name` argument to `git push`,

Term also used by commands such as `pull` and `fetch`.

## omit refspec

What happens on:

    git push <remote>

depends on the `push.default` option, documented under `man git-config`:

-   `matching`: same as `git push <remote> :`. Default before 2.0. Insane because it does a mass update operation by default!

-   `upstream`: push the current branch to its upstream branch.

-   `simple`: like `upstream`, but don't push if the remote branch name is different from the local one: you need en explicit refspec for that. Default starting on 2.0.

-   `current`: push the current branch to a branch of the same name. Simple, explicit and does not depend on any configuration.

-   `nothing`: do nothing. For those overly concious with safety. Forces you to always use the branch name explicitly.

## Omit the remote

### Before 2.0

    git push

is the same as:

    git push <remote>

where `<remote>` is:

- the tracking remote (`branch.<name>.remote`) of the current branch if it has one
- `origin` otherwise

The sanest configuration for the GitHub workflow:

-   let `origin` be the clone, `up` the upstream.

-   push the first time with `git push -u origin`, and further pushes just with `git push`

-   fetch and pull with `git fetch up`

    This longer form (with explicit `up`) seems unavoidable before Git 2.0 if we want to be able to do just `git push`, which is a more common operation than `fetch` and thus should be the shorter one.

### After 2.0

More configuration variables were added. The search order is:

- `branch.<name>.pushremote`
- `remote.pushdefault` (affects all branches)
- `branch.<name>.remote`
- `origin`

The sanest configuration for the GitHub workflow:

- let `origin` be the upstream, `mine` the clone.
- let `remote.pushdefault` be `mine`
- now you can both fetch and push directly with `git fetch` and `git push`

## u

## Upstream

## Tracking branch

Each local head can have a remote branch to which it pulls and pushes by default, which is known as it's upstream.

The upstream is set under the `branch.<name>.remote` configuration.

Note that for `push`, other configurations come into play after Git 2.0, in particular `remote.pushdefault` and `branch.<name>.pushremote`, so the concept is more strongly related to fetching.

Push and also set the upstream of current branch:

    git push -u remote branch

Set the upstream without push for current branch:

    git branch --set-upstream remote branch

Get a list of all upstreams:

    git branch -vv

Also shows the very useful ahead behind statistic on the tracked remote.

There seems to be no clean plumbing way to get the corresponding upstreams of all branches programmatically without grepping: <http://stackoverflow.com/questions/4950725/how-do-i-get-git-to-show-me-which-branches-are-tracking-what>

For scripts for a single branch:

    git rev-parse --abbrev-ref master@{upstream}

## f

## force

Push to remote branch even if the remote branch is not a descendant of the local branch.

I think this:

- finds the closest common ancestor of the remote
- makes everything that comes after a [dangling commit]
- mounts the local changes on the command ancestor

May lead to data loss.

Example:

    ./clone.sh multi
    cd a
    git reset --hard HEAD~
    # Does not work.
    git push
    # Works.
    git push -f
    git cd ../ao
    # We're on 1.
    git log --pretty=oneline
    # One dangling commit.
    git fsck --lost-found

After you `push -f`, collaborators have to rebase. The fastest way to do that is with:

    git pull --rebase

---

Push all branches:

    git push origin --all

It is possible to push the current branch by using:

    git config push.default current

## delete

Delete remote branch:

    git push origin --delete branch

or:

    git push origin :branch

Can only delete a branch if it is not he current remote branch.

Modify current remote branch: <http://stackoverflow.com/questions/1485578/how-do-i-change-a-git-remote-head-to-point-to-something-besides-master>

After you delete remote branches, you can remove the local tracking branches with:

    git remote prune origin

