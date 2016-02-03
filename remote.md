---
title: remote
social_media: true
permalink: git-tutorial/remote/
---

Manage remote repositories.

When you clone something, it already has a remote called `origin`.

Remotes are short names that point to URLs. They are stored under `.git/config` as:

    [remote "<remote-name>"]
      url = http://github.com/user/repo

There are also other remote related variables configurations that can be stored under `[remote]`, in including `fetch`.

## View remote

Shows remote repo aliases without their real addresses:

    git remote

Shows remote repo aliases and their real addresses:

    git remote -v

View detail of branch:

    git remote show $B

## remote add

One way to avoid typing the repo URL is giving it an alias with `remote add`:

    git remote add origin git@github.com:userid/reponame.git

Origin can be any alias we want, but `origin` is a standard name for the main remote repo.

And now you can do:

    git push origin master

You can view existing aliases with:

    git remote -v

Which gives:

    origin  git@github.com:cirosantilli/reponame.git (fetch)
    origin  git@github.com:cirosantilli/reponame.git (push)

## Modify remotes

Remove the remote branch called GitHub:

    git remote rm github

Change the address of a remote:

    git remote set-url git://github.com/username/projectname.git

## prune

Remove all remote refs under under `remotes/origin` such that their remote it tracks has been deleted:

    git remote prune origin

Useful after `push --delete` or when the remote was deleted via the web interface, e.g. after the pull request was merged.

Also possible with:

    git fetch -p

The actual branches will still be there. Delete merged branches, i.e. any ancestor of the current branch, with:

    git branch --merged | grep -v "\*" | xargs -n 1 git branch -d

<http://stackoverflow.com/questions/6127328/how-can-i-delete-all-git-branches-which-have-been-merged>

## remote head

Is a head that has a name.

It is not a branch however!

If you checkout to them, you are in a detached head state.

## view remote branches

First fetch the branches with:

    git fetch remote

View only remote branches, not local ones:

    git branch -r

View all branches, local and remote:

    git branch -a

They are listed like `remote/\<remote-name>/\<branch-name>`

Where remote-name was either given:

- explicitly by `remote add`
- `origin` by default by `clone`

## how to refer to one

Documentation at:

    git rev-parse

`SPECIFYING REVISIONS` section.

Depends on the command.

The best way is explicitly `<remote-name>/<branch-name>` but some commands do explicit stuff if you enter just `<branch-name>` and there is no other branch in your repo with that name.

Ex: `origin/master`, `origin/feature2`, `upstream/feature2`, etc.

### branch

Branch only sees remotes if you give the `remote-name` explicitly.

### Checkout to a remote without specifying which remote

If you have a tracking branch `origin/b`, no other tracking branch of the form `some-remote/b`, and no branch named `b`:

    git checkout b

is expanded to:

    git checkout -b <branch> --track <remote>/<branch>

which will create the local branch for you and make it track the right thing.

Note however that:

    git checkout -b b

Is the same as:

    git branch b
    git checkout b

so it will create the branch `b` from the current commit.

This only works for the `origin` remote. For custom remotes you have to use the full form.

