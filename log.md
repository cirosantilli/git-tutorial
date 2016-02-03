---
title: log
social_media: true
permalink: git-tutorial/log/
---

List revisions. Highly customizable output format.

## Basic usage

Start with [2]. List versions in chronological order:

    git log

Sample output:

    commit 1ba8fcebbff0eb6140740c8e1cdb4f9ab5fb73b6
    Author: Ciro Santillli <ciro@mail.com>
    Date:   Fri Apr 12 10:22:30 2013 +0200

        2

    commit 494b713f2bf320ffe034adc5515331803e22a8ae
    Author: Ciro Santillli <ciro@mail.com>
    Date:   Thu Apr 11 15:50:38 2013 +0200

        1

In this example, there are 2 versions, one with commit message `1` and another with commit message `2`.

On version `1` we see that:

- author name: `Ciro Santilli` (specified in `git config`)
- author email: `ciro@mail.com` (specified in `git config`)
- commit hash: `494b713f2bf320ffe034adc5515331803e22a8ae`.

## Search criteria

### all

Start searching from all refs:

    git log --all

Includes:

- on other branches besides the current (by default only current branch is shown):
- future commits when navigating history

### Range

    git log rev1..rev2

If any of them is omitted, it defaults to `HEAD`. Major application: see differences between a branch and its remote.

Outdated remote origin:

    git fetch origin
    git log origin/master..

Updated upstream:

    git fetch upstream
    git log ..upstream/master

To simply count the number of different versions, consider `git branch -vv`

### grep

Show only if grepping commit messages match:

    git log --grep 1

### S

Find commits that added or removed a given word (it appears on the diff):

    git log -Sword

This is *slow*!

Note that this excludes commits that touch the same line as `word` but don't add or remove it.

### G

Find commits whose diff contain the given word:

    git log -Gword

### diff-filter

View deleted files only:

    git log --diff-filter=D --summary
    git log --all --pretty=format: --name-only --diff-filter=D

Useful to find when you deleted a file from a repo if you don't know its exact path!

### follow

Also cross `git mv`:

    git log --follow -p file

If a merge occurs, both branches appear on `git log` and get mixed up chronologically and it is impossible to set them apart.

### first-parent

Show only history of the current branch ignoring merges:

    git log --first-parent

This is a great option to view history on a feature branch onto which upstream was merged from time to time. Rebase is a better option than merge in this case if you work locally, but may not be an option if a group is working on the feature branch.

### max-parents

### min-parents

Filter by the number of parents.

Find all root commits:

    git log --max-parents=0

## Display mode

### p

### patch

Show every commit and diff (Patch) of a single file:

    git log -p file

### n

View up to a certain number of log messages (most recent):

    git log -n 1

`-n 1` is specially useful if you want to get information on the current commit, specially when used with `pretty=format`.

### format

The `--pretty` option allows for any output format. There are also options which are aliases to useful formats that can be achieved with `--pretty`.

Same as `--abbrev-commit` and `--pretty=oneline`:

    git log --oneline

View hash and commit messages only, one per line:

    git log --pretty=oneline

Show short hashes:

    git log --abbrev-commit

Use a custom format string:

    git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short

See `man git log` and grep for `format:` for a list of all formats.

There seems to be no built-in way to do fixed column widths, but that can be worked around with `column`:

    git log --pretty=format:'%C(yellow)%h|%Cred%ad|%Cblue%an|%Cgreen%d %Creset%s' --date=short | column -ts'|' | less -r

### graph

Show text commit tree:

    git log --oneline --graph

Sample output:

    *   0f055197776275cdf55538469a07cf8d5e13ad24 Merge pull request #6610 from Datacom/feature/parallel_diff_scrollbars_pr2
    |\
    | * 83f811fff5f6b2188c82f187f747122d2f7cd936 Refactor Parallel Diff feature and add scrollbars
    * |   cf7aab9b441f61a0db11f1f20887db1862c8c791 Merge branch 'master' of gitlab.com:gitlab-org/gitlab-ce
    |\ \
    | * \   24e9c5e83e1b5b304aa0109e95bbd69a554f5e3f  Merge branch 'bugfix/fix_unicorn-sidekiq_confusion_in_gitlab_init_script' into 'master'
    | |\ \
    | | * | 058aae5940762c18b3f099a6c3cb734041641390 Fixed Unicorn-Sidekiq confusion in GitLab init script.
    * | | |   aabd90a828eeb1b1c2fd82afd674d965aaa2dde3 Merge branch 'master' of github.com:gitlabhq/gitlabhq

The asterisks `*` show which branch the message on the right corresponds to.

### decorate

Also show refs for each commit:

    git log --decorate --pretty=oneline

Sample output:

    abc2f322034989737e0c7654ecbeaa1009011bb6 (HEAD, normalize) Improve output normalization with custom parser.
    9b397b1d09f126aeba985aed8c41bf86ba0b0e58 Add -l option.
    9dc5a1a74d65fdb3e1d6aa23365089a0d8d7a6ed Add -n option.
    d99ce39e4c37c869ba2b98f593f31d00842c8c99 Add -s option.
    2fba1c4ba0574027fe8845aa5ce63edea677824f (up/master, origin/master, origin/HEAD, only-ext, master) Merging and resolving conflict

### simplify-by-decoration

Only show commits that:

- have a ref
- are required to understand history of commits with a ref. Basically merge events.

Especially meaningful with `--graph`, where it becomes clear why the extra commits are added:

    git log --decorate --graph --pretty=oneline --simplify-by-decoration

Sample output:

    * b60e1176d0f1be90902e117e6bb45b712024ade0 (HEAD, origin/one-test, one-test) Add -a option.
    *   2fba1c4ba0574027fe8845aa5ce63edea677824f (up/master, origin/master, origin/HEAD, only-ext, master) Merging and resolving conflict
    |\
    | * 7033e24a572fdd1f88d5b0eb67bf08599ca655d9 (origin/document-config-local) Document config_local.py on README.
    * |   7ab3a61a7a5b95bffb4704e3b2824613099f140e Merge pull request #24 from cirosantilli/factor-out-engines
    |\ \
    | * | 4ae853d571046c18705f49520e501c9affbe2812 (origin/factor-out-engines) Factor out engines that are commands on PATH.
    * | |   e69627cbf9a576ded85fadd7a1e1325499f462cf Merge pull request #25 from cirosantilli/sample-output-readme
    |\ \ \
    | * | | 3e4684cd291e54c79028c58c8241254771d9ceca (origin/sample-output-readme) Add sample run-tests.py output to README.
    | |/ /
    * | | 1f7b2547d1965f2887146929e55eecc881eabb9f (origin/check-no-engines) Check if are no engines enabled to avoid exception.
    |/ /
    * |   710e9adf53d7cdd1f3888a3dbeacb38d07deaf49 Merge pull request #20 from cirosantilli/multimarkdown

### source

Show from which refs the commit was reached. Useful with `--all`

Commit lines will be of the type:

    commit 8d8140843501107c92e2f9a5acb60ee136352c1f	refs/tags/v2.3.0-rc0

instead of:

    commit 8d8140843501107c92e2f9a5acb60ee136352c1f	

So we see that this commit was found from `refs/tags/v2.3.0-rc0`.
