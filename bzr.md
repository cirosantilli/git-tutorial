---
title: Bazaar and Launchpad for Git users.
---

##  Why it exists?

Because Canonical is stuck to its dying solution and is not making an effort to move out.

Initial release of bzr was around at the same time as Git.

Today Git is probably infinitely more used, and Canonical is probably by far the major `bzr` user.

`bzr` even has Launchpad specific commands built-in.

Perhaps this was not clear in the past, but today I am not the only one to wonder: how can they not transition to git?

- <http://lwn.net/Articles/578936/>
- <http://askubuntu.com/questions/32084/why-does-ubuntu-use-launchpad-instead-of-github-or-bitbucket>

At least basic commands look exactly like Git.

##  help

    bzr help
    bzr help init

##  Setup

TODO where is this information stored?

###  whoami

Required to commit:

    bzr whoami "Your Name <name@example.com>"

View current `whoami`:

    bzr whoami

###  launchpad-login

Required to push to launchpad:

    bzr launchpad-login LAUNCHPAD_LOGIN

View current login:

    bzr launchpad-login

##  init

    bzr init

Creates a `.bzr` directory.

## ignore

Adds lines to `.bzrignore`:

    bzr ignore "*.out" "*.exe"

## add

    bzr add README.md

## status

    bzr status

Sample output:

    added:
      README.md

## commit

    bzr commit

## push

    bzr push lp:~$LAUNCHPAD_LOGIN/test/branch

TODO: what is `lp:`? What are other possible values?

## clone

## branch

    bzr branch lp:~$LAUCHPAD_LOGIN/+junk/branch
