---
title: Git Version Control Tutorial
---

<ol data-toc></ol>

# Sources

-   Short help: `git help`

-   List all commands: `git help -a`

-   Some guides:`git help -g`. General useful ones:

    - `man gitrevisions`: how to name revisions
    - `man gitrepository-layout`: what is inside `.git`
    - `man gitglossary`: index of Git terms

-   Help for a command: `git add --help`. Same as `man git-add` or `man git add`.

-   Official source code:

        git clone git://git.kernel.org/pub/scm/git/git.git

    Official read only mirror on GitHub:

        git clone https://github.com/git/git

    In particular, the `Documentation` directory contains no only the source for the man pages,
    but also many tutorials and internals information which are not present in the man pages.

    - `Documentation/technial`: internals
    - `Documentation/howto`: tutorials

-   <https://git.wiki.kernel.org/index.php/Main_Page>

    Official wiki.

-   Issues, questions and patches are sent by email at: <git@vger.kernel.org>

    You subscribe by sending an email to <majordomo@vger.kernel.org >,
    but it is around 100 posts / day!

    There are web interfaces subscribed that store old threads.

    -   the most popular and often linked to as the canonical URL seems to be:
        <http://dir.gmane.org/gmane.comp.version-control.git>
        but as a millennial I find it really hard to navigate.

    -   <http://git.661346.n2.nabble.com/> is a more usable option

    TODO: what is `vger`? Is it a Star Trek reference: <http://en.memory-alpha.org/wiki/V%27ger>?
    Would make some sense as in the Star Trek canon it is the name
    of an entity which aims to absorb as much knowledge as possible.

-   Tutorials from companies who make money from Git:

    -   <http://git-scm.com/book>.

        Apparently GitHub maintained but officially adopted by Git:
        <https://github.com/blog/1125-new-git-homepage>

        Good info and graphs.

        Leaves out many practical things.

    -   <http://learn.github.com>

    -   <https://www.atlassian.com/git/tutorials>

-   Good tutorial: <http://cworth.org/hgbook-git/tour/>

-   Good tutorial, straight to the point, ASCII diagrams:
    <http://www.sbf5.com/~cduan/technical/git/git-1.shtml>

-   Description of a production / dev / hotfix branch model:
    <http://nvie.com/posts/a-successful-git-branching-model/>

# Why learn Git

Git + GitHub allows you to do the following quickly:

-   create multiple versions (*commits* or *revisions* in Git jargon)
    of your work, and travel between them.

    This is useful for:

    -   backup. If you delete a file by mistake, and the file was present
        in some past version, you can recover it.

    -   if a recent modification made a change that made things worse,
        you can just go back to a previous correct state and see what happened.

    -   refer to a specific version.

        Say you are writting a book, and you made a session called "motivation".

        Other people liked it, and said, look at the motivation section!

        But one day, you decide that the motivation section should be called "advantages" instead.

        But then this breakes the references of other people...

        But not if the other person said: look at the "motivation" section of **version** XXX!

    -   you are working on a feature, when something more urgent comes up.

        The current state may not be stable, and may interfere with the more urgent state.

        No problem, make a version of your current work to save it,
        and switch to the more urgent matter.

        When you are done, just switch back.

    -   View differences between versions.

        It is easy to [view *differences* between versions](#differences)
        to find out what was different on a different version

        This is useful when:

        - why was my program working then, but stopped working?

        - what changes exactly did someone else made to my files and wants me to accept?

    There are many commands that deal with versions, but you should first learn:

    - `git add`, `git rm` and `git mv` decide which files to include on the next version
    - `git commit` creates versions
    - `git checkout` moves between versions
    - `git branch` deals with version names

-   Upload your work to a server to:

    - back it up
    - publish it

    The main command to do those things is `git push`.

-   Download something someone else made public. `git clone` is the way to go.

-   Work in groups.

    Because of all its capacities, git is widely used in group projects. It was *created* for the Linux kernel.

    This means that:

    - you can make a very large project that need many people to work on the same code.

    - you can learn from others.

    - if you make a good work, you will get more famous, and will have better jobs.

    For open source, this also means that:

    - you can make modifications that you need to the program you use.

# How to learn Git

Git is hard to learn at first because

- it has inner state that is not obvious at first to visualize.

- concepts depend on one another egg and chicken style.

To learn it:

-   make a bunch of standard test repos, copy them out, and *test away*.

    Use the standard repos generated in [test repos]

-   visualize *everything* the commit tree whenever you don't know what is going on.

    Once you see the tree, and how to modify it, everything falls into place!

# Base concepts

## Repository

Git works inside the directories you tell it to work.

Those directories are called *repositories*, *repo* for short.

The only thing that makes a directory in to a repository is the presence of a `.git` folder
with the correct files in it, which contains most of the `.git` data.
Some more may be contained in config files outside `.git` like `.gititnore`.

To create a new repo, use `init`.

To copy an existing repo, use `clone`. No need to `git init` it after you clone it.

To transform a repo into a non repo, simply remove the `.git` dir (and maybe other files like `.gitignore`).

## Three trees

This is a confusing point for beginners, but it is a good design choice by Git,
so understand it now and save lots of trouble later.

The three trees are:

- working tree: regular files outside `.git`. Those files may not be tracked by Git.
- index: things that have been selected to be added to the next revision. Internally, not represented as a tree object.
- `HEAD`: the last version. Internally, a tree object.

Transitions:

    +--------------+  +--------------+  +------+
    | working tree |  | staging area |  | HEAD |
    |--------------+  |--------------+  |------+
    |                 |                 |
    |                 |                 |
    | -- add -------> | -- commit ----> |
    |                 |                 |
    |                 |                 |
    | <- reset ------ | <- reset ------ |

# Setup

Before anything else install Git.

On on Ubuntu 12.04 do:

    sudo apt-get insatll git

Next configure git:

    git config --global user.name "Ciro Santilli"
    git config --global user.email "ciro@mail.com"

You will also want to install a local GUI git viewer:

    sudo apt-get insatll gitk

It makes it easier to see the version tree.

# init

Create an empty git repository inside the current directory:

    git init

This creates a `.git` dir that contains all the git information.

# Create version

Most of git operations are based on versions, so you'd better know how to create them!

To create a version you need to:

- decide what files will be included in the version with `add`, `rm`, `mv`, and many others.
- create the version with `commit`

You can see what would be included in the next version with `status`

# status

Lists:

- differences between working tree and index, including files not present in the index
- differences between index and `HEAD`

Entire repository:

    git status

Only in a given directory:

    git status .

You can change what would be added with commands like `add`, `rm` or `reset`

There are 3 most common possible sections:

- `Untracked files`: files which have never been added in any version.
- `Changes not staged for commit`: files which have changed but will not be considered.
- `Changes to be committed`: files which which have changed and will be considered

Other sections also exist:

- `Unmerged paths`: while on a merge conflict resolution.
    You must first add those files and then `git rebase --continue`.

And if nothing changes, it says so.

Check out the `add`, `rm` and `reset` commands to see how it behaves.

# Working tree

Is all the "regular" files that lie outside the `.git` directory.

# Index

A temporary place where you can build the next commit little by little.

Its existence allows you for example to do several `git add` separately,
edit some more, and only later create a new version. For this to work,
operations like `git add` must store the files somewhere: this place is the index.

Usually modified with the following commands:

- `add`:          add file so index. Don't touch working tree.
- `rm`, `mv`:     remove and rename from both index and working tree.
- `reset`:        set the index to the same as last commit, therefore undoing operations like `git add`.
- `checkout ref`: sets the index to the tree of the ref, therefore radically modifying it.

The index is stored internally by Git in the `.git` directory. Therefore,
after you `git add` a file for example, you can remove it from the working tree
but you won't lose any data.

## Index internals

Internally, the index is stored under `.git/index`, not as a standard tree object.
<http://stackoverflow.com/questions/4084921/what-does-the-git-index-exactly-contain>
This is probably because it contains filesystem metadata like timestamps to do it's job.

Its format is binary and documented at:
<https://github.com/git/git/blob/master/Documentation/technical/index-format.txt>

The index format has evolved with time. Currently there exists version up to 4.
2 is common. The format version is stored in the index.

When we do:

    git init
    echo a > b
    git add b
    tree --charset=ascii

We get:

    .git/objects/
    |-- 78
    |   `-- 981922613b2afb6025042ff6bd878ac1994e85
    |-- info
    `-- pack

And after:

    git cat-file -p 78981922613b2afb6025042ff6bd878ac1994e85

We get `a`. This indicates that:

- the `index` points to the file contents, since `git add b` created a blob object
- it stores the metadata in the index file, not as a tree object

Now:

    hd .git/index

gives:

    00000000  44 49 52 43 00 00 00 02  00 00 00 01 54 09 76 e6  |DIRC.... ....T.v.|
    00000010  1d 81 6f c6 54 09 76 e6  1d 81 6f c6 00 00 08 05  |..o.T.v. ..o.....|
    00000020  00 e4 2e 76 00 00 81 a4  00 00 03 e8 00 00 03 e8  |...v.... ........|
    00000030  00 00 00 02 78 98 19 22  61 3b 2a fb 60 25 04 2f  |....x.." a;*.`%./|
    00000040  f6 bd 87 8a c1 99 4e 85  00 01 62 00 ee 33 c0 3a  |......N. ..b..3.:|
    00000050  be 41 4b 1f d7 1d 33 a9  da d4 93 9a 09 ab 49 94  |.AK...3. ......I.|
    00000060

Breaking it up:

- `44 49 52 43`: `DIRC`
- `00 00 00 02`: format version: 2
- `00 00 00 01`: count of files on the index: just one

Next starts a list of index entries. Here we have just one. It contains:

-   a bunch of file metadata: 8 byte `ctime`, 8 byte `mtime`,
    then 4 byte: device, inode, mode, UID and GID.

    Note how:

    -   `ctime` and `mtime` are the same (`54 09 76 e6 1d 81 6f c6`)
        as expected since we haven't modified the file

        The first bytes are seconds since EPOCH in hex:

            date --date="@$(printf "%x" "540976e6")"

        Gives:

            Fri Sep  5 10:40:06 CEST 2014

        Which is when I made this example.

        The second 4 bytes are nanoseconds.

    -   UID and GID are `00 03 e8`, 1000 in hex: a common value for single user setups.

    All of this metadata allows Git to check
    if a file has changed without comparing the entire contents.

-   at start line `30`: `00 00 00 02`: 4 byte file size: 2 bytes

-   20 byte SHA-1 of the content: `78 98 19 22 ... c1 99 4e 85`

-   2 byte flags: `00 01`

    -   1 bit: assume valid flag. TODO

    -   1 bit extended flag. Determines if the extended flags are present or not.
        Must be `0` on version 2 which does not have extended flags.

    -   2 bit stage flag used during merge. Stages are documented in `man git-merge`:

        - 0: regular file, not in a merge conflict
        - 1: base
        - 2: ours
        - 3: theirs

        During a merge conflict, all stages from 1-3 are stored in the index
        to allow operations like `git checkout --ours`.

        If you `git add`, then a stage 0 is added to the index for the path,
        and Git will know that the conflict has been marked as solved.

        TODO: check this.

    -   12 bit length of the path that will follow: `0 01`: 1 byte only since the path was `b`

-   2 byte extended flags

-   `62` (ASCII `b`): variable length path. Length determined in the previous flags.

-   `00`: zero padding so that the index will end in a multiple of 8 bytes. Only before version 4.

Finally we have a 20 byte checksum `ee 33 c0 3a .. 09 ab 49 94` over the content of the index.

## checkout-index

Add files from the index to the working tree.

Plumbing.

## update-index

Add files from working tree to index.

Plumbing.

## read-tree

Read given tree object into the index.

Plumbing.

## write-tree

Create a tree object form the index.

Plumbing.

# Staged

When a file on the working tree is added to the index, its changes are said to be *staged*.

By analogy, if you modify the working tree and don't add it to the index,
the changes are said to be *unstaged*.

# ls-files

List files in the index and working tree recursively according to several criteria.

List all tracked files under current dir newline separated:

    git ls-files

Sample output:

    .hidden
    file
    dir/file

Untracked files only:

    git ls-files --other

TODO only files in current dir?

# grep

Search for lines in tracked files.

If you only want to search the entire current tree,
`ack -a` is probably better as it has better formatted output.

There are however cases where `git grep` shines:

- it is crucial to ignore ignored files
- search in other revisions

Do a `grep -r 'a.c' .` only on tracked files of working tree:

    git grep 'a.c

It true, `-n` by default:

    git config --global grep.lineNumber

It true, `-E` by default:

    git config --global grep.extendedRegexp

Search in revision:

    git grep a.c 1.0

Search in revision only under directory:

    git grep a.c 1.0 -- dir

`-l`: list files without any other data:

    git grep -f a.c | xargs perl -lane 's/a/b/p'

# Binary files

## How Git determines if a file is binary

Git has an heuristic for determining if files are binary or text:
it is not possible to do identify file types precisely.

If a file is binary affects such as not showing diffs in such files,
which would be meaningless line-wise.

In 2014, the heuristic is: look up to 8000 bytes at the beginning of the file.
Binary iff there is a `NUL` (`\0`).

This heuristic has the interesting property that it works for UTF-8,
whose only 0 byte represents the NUL character.
Unfortunately if fails for UTF-16.

<http://stackoverflow.com/questions/7110750/how-do-popular-source-control-systems-differentiate-binary-files-from-text-files>

## List all text files

<http://stackoverflow.com/questions/18973057/list-all-text-non-binary-files-in-repo>

    git grep -Ile ''

Add trailing newlines to all text files that don't have them:

    git grep -Ile '' | xargs perl -lapi -e 's/.*/$&/'

## Check if a file is binary

<http://stackoverflow.com/questions/6119956/how-to-determine-if-git-handles-a-file-as-binary-or-as-text>

    if [ -n "$(git grep -Ile "" -- "$file")" ]; then echo "Text"; fi

## Force file to be treated as binary

<http://stackoverflow.com/questions/11162267/how-do-i-make-git-treat-a-file-as-binary>

## Force file to be treated as text

<http://stackoverflow.com/questions/777949/can-i-make-git-recognize-a-utf-16-file-as-text>

## Diff for binary files

It is necessary to first convert the file to a text format if possible.

This can be done automatically through the `textconv` option for specified files.

There exist tools that do the conversion reasonably for documents such as `.doc` or `.odt`.

## U

## inter-hunk-context

## Hunk

The name of each contiguous modified chunk in a file.

Each hunk is delimited by an `@@` line on the default diff output format.

When Git merges two hunks is controlled by both the `-U` and `--inter-hunk-context` options.

`-U` determines the minimum number of context lines to show. It defaults to 3.

`--inter-hunk-context` determines the maximum extra number of lines
between two contexts before the hunks are merged.
It defaults to 0: hunks are only merged by default if the contexts touch.

Consider the following edit:

    1 -> a
    2    2
    3    3
    4    4
    5    5
    6    6
    7    7
    8    a

Then:

    git diff -U

shows:


    @@ -1,8 +1,8 @@
    -1
    +a
     2
     3
     4
     5
     6
     7
    -8
    +a

Hunks touched with 3 lines of context, and were merged.

    git diff -U2

Gives:

    @@ -1,3 +1,3 @@
    -1
    +a
    2
    3
    @@ -6,3 +6,3 @@
    6
    7
    -8
    +a

Hunks did not touch anymore, so split up.

If we want to force them to merge anyways, we need to bridge two lines: 4 and 5. So we can do:

    gdf --inter-hunk-context=2 -U2

And once again that gives:

    @@ -1,8 +1,8 @@
    -1
    +a
     2
     3
     4
     5
     6
     7
    -8
    +a

It is sometimes possible to operate on separate hunks. E.g., `git add -i` allows that.

# blame

See who last modified each line of a given file and when (so you can blame for the bug the line caused...)

Sample output:

    2c37fa38 (Sergey Linnik          2012-11-19 02:36:50 +0400  71)     size = 40 if size.nil? || size <= 0
    2c37fa38 (Sergey Linnik          2012-11-19 02:36:50 +0400  72)
    757c7a52 (Riyad Preukschas       2012-12-15 02:19:21 +0100  73)     if !Gitlab.config.gravatar.enabled || user_email.blank?
    a9d1038f (Jeroen van Baarsen     2013-12-16 21:56:45 +0100  74)       '/assets/no_avatar.png'
    65bcc41f (Robert Speicher        2012-08-15 21:06:08 -0400  75)     else

It does not seem possible to count how many lines each user changed in a single Git command as of 1.8.4,
but the manual itself suggests a command to do so:

    f=
    git blame --line-porcelain "#f" | sed -n 's/^author //p' | sort | uniq -c | sort -rn

For the entire repo: <http://stackoverflow.com/questions/4589731/git-blame-statistics>

See who last modified all files in project:
<http://serverfault.com/questions/401437/how-to-retrieve-the-last-modification-date-of-all-files-in-a-git-repository>

Ignore whitespace only changes (e.g. indent):

    git blame -w

Attribute moved lines to the original author, not the mover (TODO understand `C` and `M` precisely):

    git blame -CM

# gitignore

See `man gitignore`

`.gitignore` are files that tell git to ignore certain files,
typically output files so they won't for example clutter your `git status`.

A `.gitignore` can be put anywhere in the repo and affects current dir and all descendants.

You should *always* put all output files inside a gitignore.

There are two common strategies to to that:

-   by file extension

    `*.o` to ignore all object files.

    This is has the downside that you may have to add lots of extensions to the gitignore.

-   by directory

    `_out/` to ignore all files in `_out/`.

    This is has the downside that some (bad) programs cannot output to or use files from other directories except the current...

## syntax

`.gitignore` uses slightly modified bash globbing. Reminders:

-   bash globbing is strictly less powerful than regexes

-   regex equivalence

        glob        regex
        --------    --------
        `*`         `.*`
        `*.o`       `.*\.o`
        `[1-3]`     `[1-3]`
        `[a-c]`     `[a-c]`

    so there is not equivalence for:

    - regex Kleene star: `*`
    - regex alternatives: `(ab|cd)`

If a pattern does not contain a slash `/`, it matches any entire basename in any subdir:

    echo a > .gitignore
    git status
        #untracked: b d/
    git add d
    git status
        #untracked: b
        #new file: d/b

If the pattern contains a slash `/`, only files under the given directory can match.
E.g.: `d/*.c` matches `d/a.c` but not `d/e/a.c`.

If you want to ignore by basename under a given directory only, put a `.gitignore` into that directory.

If the pattern starts in `/`, only files under the same directory as the gitignore file can match.
E.g.: `/*.c` matches `/a.c` but not `/d/a.c`.

Trying to add an ignored file gives an error:

    git reset
    git add a
        #error, a ignored, use -f if you really want to add it

You can ignore entire directories:

    echo d > .gitignore
    git status
        #untracked: a b

`.gitignores` are valid on all subdirectories of which it is put only:

    echo a > d/.gitignore
    git status
        #untracked: a b d/
    git add *
    git status
        #new file: a b d/b

If a pattern starts with a `!`, it unignores files. Ignore all files except the gitignore itself:

    *
    !.gitignore

Ignore all files except the gitignore itself and another file:

    *
    !.gitignore
    !README.md

## local gitignore

`.git/info/exclude`

Does not get pushed to remote.

Same syntax as `.gitignore`.

# git file

The `.git` file, not directory. TODO

# mailmap

Config file named `.mailmap` file at the repo root.

Allows authors to change emails / usernames while keeping a single identity.

Put lines like this in that file:

    Old Name <old_email@mail.com> New Name <new_email@mail.com>

Things will work well with this, for example [shortlog].

# add

Make Git track files for next version

    add a
    add a b

Check that it will be considered for next version with:

    git status

## Example: add

Start with [1]:

    echo a2 >> a

    git status
        #not staged: modified: a

    git add a
    git status
        #to be committed: modified: a

You must add after making the desired modifications.

If you add and then modify, only the first addition will be taken into account for next version.

    echo a2 >> a

    git status
        #to be committed: modified: a
        #not staged:      modified: a

    git add a

    git status
        #to be committed: modified: a

Add is recursive on directories:

    mkdir d
    echo a > d/a
    git status
        #to be committed: modified: a
        #untracked: d/

    git add d
    git status
        #to be committed: modified: a
        #to be committed: new: d/a

## add and gitignore

If you add a file that is in `.gitignore` directly, the add fail.

However, if you add a directory that contains gitignored files,
then those files are ignored and the ignore succeeds.

Therefore, for example to add all files in the current it is better to use:

    git add .

and not:

    git add *

which fails if there are gitignored files.

`git add .` also has the advantage of including hidden dot files `.`.

# rm

If you want to remove a file that is tracked from future versions then use:

    git rm a

A simple `rm a` will not remove it from next version.

If you already did `rm a`, then doing `git rm a` will work even if the file does not exist.

Note however that this file still can be accessed on older versions!

If you committed sensitive data like passwords like this by mistake, you need to remove it from history too!

To do that see [remove file from repo history].

## Example: rm

Start with [1]

    rm a
    git status
        #not staged: removed a
    echo b2 >> b
    git add b
    git commit -m 2

Then `a` is still in the repo:

    git checkout a

Restores a.

If you use `commit -a`, it gets removed anyway:

    rm a
    git status
        #not staged: removed a
    echo b2 >> b
    git add b
    git commit -am 2

You could also `git add` or `git rm` after a bare `rm`:

    rm a
    git add a

Or

    rm a
    git rm a

And a will be removed.

## rm --cached

Don't remove the file from working tree, but stop tracking it for next commit.

    ./copy.sh 1
    git rm --cached b
    git status
        #to be committed: deleted: b
        #untracked: b
    git add b
    git status
        #nothing to be committed

## rm -f

Remove even if it has local changes.

By default this is not permitted.

    ./copy.sh 1
    echo a2 >> a
    git rm a
        #error: a has local modifications
    git rm -r a
    ls
        #b

## rm -r

Remove all files descendants of a dir recursively.

By default, `git rm` won't remove dirs.

# Remove file from repo history

`rm` does not remove files from repo history, only from future versions.

So if you mistakenly committed:

- sensitive data like a password

- some large output file like an `.ogv`

Do this:

    UNAME=cirosantilli
    REPONAME=cpp
    REPOURL=https://github.com/$UNAME/$REPONAME.git
    RMFILE="*.ogv"

    git filter-branch --index-filter "git rm --cached --ignore-unmatch \"$RMFILE\"" --prune-empty -- --all

Remove from local dir

    rm -rf .git/refs/original/
    git reflog expire --expire=now --all
    git gc --prune=now
    git gc --aggressive --prune=now

Remove from repo:

    git push origin master -f

**Mail all colaborators** and tell them to git rebase

# clean

**danger**: remove all untracked files in repo that are not in gitignore:

    ./copy.sh 1

    echo c > c
    echo c > d/c

Dry run with `-n`:

    git clean -n

Output:

    would remove c
    would not remove d/

Since this is a very dangerous operation, in `Git 1.8` the default is to do dry runs.
This can be controlled by the `clean.requireForce` configuration option,
and an `-f` is required to actually clean. Do not rely on the value of this option.

Remove entire directories with `-d`:

    git clean -dn

Output:

    would remove c
    would remove d/

Not dry run with `-f`:

    git clean -df

Output:

    would remove c
    would remove d/

By default, to make a non dry run, you have to add `-f`, but this depends on your git configurations.

Also remove untracked files listed in `.gitignore` with `-x`:

    git clean -dfx

# mv

Similar to [rm].

If you do a normal `mv`, then it is as if the old file was removed and a new one was created:

Start with [1].

    mv b c
    git status

Output:

    removed: b
    untracked: b

If you do `git mv`, git acknowledges it was moved:

    mv b c
    git status
        #renamed: b -> c

With `-f`, if the new path exists, it is overwritten:

    git mv -f "$OLD_PATH" "$NEW_PATH"

With `-k`, if moving would lead to an error (overwrite without -f or file not tracked), skip the move:

    git mv -k "$OLD_PATH" "$NEW_PATH"

# reset

Move the current branch and possibly index and working directory to one of its ancestor commits.

Changes history.

Create explanation: <http://git-scm.com/blog>

Without paths `git reset [option]`:

-   `--soft` moves the current branch to given ancestor commit.

    It does not touch the index nor the working directory.

    `git status` will show staged changes.

-   neither `--soft` nor `--hard` does what `--soft` does *and* changes the index to that commit.
    The working directory is unchanged.

    `git status` will show unstaged changes.

-   neither `--hard` will move the current branch, the index *and* the working directory to the given commit.

    `git status` does not show any changes.

    Changes were lost forever.

## hard vs soft

Hard also modifies the actual files and the index!

Soft does not.

    ./copy.sh 2u
    echo a3 >> a
    echo b3 >> b
    git add a b c
    git status
        #to be committed: a, b and c

With soft:

    git reset
        #unstaged: a, b
        #untracked: c
    ls
        #a b c

    cat a
        #a1
        #a2
        #a3

    cat b
        #b1
        #b2
        #b3

    cat c
        #c

So all files stayed the same as they were, but they became unstaged.

This is how you unstage a file.

With hard:

    git reset --hard
    ls
        #a b c

    cat a
        #a1
        #a2

    cat b
        #b1
        #b2

    cat c
        #c

- tracked files went back to as they were at last commit.

    Changes you made on the working tree were discarded!!

- untracked files (`c`) are unchanged, but they are unstaged.

## change what a branch points to

This changes history and as any history changing, if you do this after you [push]
and someone else [fetche]d, there will be problems!

With reset, you can change the commit a branch points to to any other commit,
even if the other commit is not an ancestor of the parent!

    ./copy.sh b2
    git reset --hard b2
    git status
        #no changes

The tree:

    (1)-----(2)
     |
     |
     |
     +------(b2)
             |
             master *
             b

### Dangling commit

`(2)` in this example is called a *dangling commit*.

It is a commit with no descendant branch.

### Delete last commit from history

Start with [2]:

    ./copy.sh 2
    echo a3 >> a
    echo b3 >> b
    echo c > c
    git reset --hard HEAD~
    ls
        #a b c

    cat a
        #a1

    cat b
        #b1

    cat c
        #c

    git show-refs -h HEAD
        #hash2

    git log --pretty=oneline
        # Only one per commit.

The tree:

    (1)-----(2)
     |
     master *

And `(2)` is called a dangling commit.

## Undo a reset hard

<http://stackoverflow.com/questions/5473/undoing-a-git-reset-hard-head1>

You can undo a reset hard if your are fast enough:
a few weeks on default configurations.

First find out the hash of the deleted commit on the reflog:

    git reflog

Then reset hard to it:

    git reset --hard HEAD@{1}

And if you just did the `reste --hard` to any commit,
you might also be able to get away simply with:

    git reset --hard ORIG_HEAD

They should show up as *dangling commits*.
This is what they are: commits that have no descendant branch.

Now merge away with the have you just found.

But *don't rely on this!*: dangling commits are removed from time to time depending on your configs.

## Remove all dangling commits permanently

<http://stackoverflow.com/questions/3765234/listing-and-deleting-git-commits-that-are-under-no-branch-dangling>

    git reflog expire --expire=now --all
    git gc --prune=now

But be sure this is what you want! There is no turning back.

# reflog

See all that was done on all branches of the repository linearly in time:

    git reflog

Contains events like:

- commits
- checkouts
- resets

Sample output:

    7c7afb3 HEAD@{0}: reset: moving to 7c7afb3
    06887ac HEAD@{1}: commit (amend): Commit message.
    7c7afb3 HEAD@{2}: checkout: moving from branch1 to branch2

The given SHA is for the `HEAD` after the operation on the line was carried out.

`HEAD@{N}` are valid revisions and can be used for any command.

The `reflog` also stores times, so you can use revision names like:

    master@{yesterday}
    HEAD@{5 minutes ago}

Internally, the reflog is stored under `.git/logs`.

One major goal of the `reflog` is to prevent accidental data loss:
for example, you can undo a `reset --hard` by using it to find the dangling commit.

# fsck

Check reachability and validity of objects.

# revert

Create new commit(s) that undo what previous commits have done.

May generate merge conflicts.

Old commit tree for all examples:

    (1)-----(2)-----(3)
                     |
                     master *

Revert a single commit:

    git revert 3

Never generates merge conflicts.

New commit tree:

    (1)-----(2)-----(3)-----(4)
                             |
                             master *

And the tree is exactly as it was on `(2)`.

You can also revert a commit other than the last one, but it may generate merge conflicts:

    git revert 1

Revert multiple commits with multiple commits:

    git revert 1..3

New commit tree:

    (1)-----(2)-----(3)-----(4)-----(5)
                                     |
                                     master *

And the working tree is exactly as it was on `(1)`. One new commit is generated for each reverted commit.

`-n`: revert multiple commits with a single new commit:

    git revert -n 1..3
    git commit -m 4

New commit tree:

    (1)-----(2)-----(3)-----(4)
                             |
                             master *

And the working tree is exactly as it was on `(1)`.

# commit

Creates a new version from the content of the index.

You must first tell Git which files will be included in the next version
by adding them to the index with commands like `add`, `rm`, `mv` and `reset`.

After you have decided what will be included or not, you are ready to commit.

This will be important later on to know what a version contains.

So from the [0](#0) do:

    git add a
    git commit -m 'added a'
    git status

To give it a message 'added a'.

Now status only says that `b` is untracked and nothing about `a`.

## Commit message

It is recommended that the commit message be like:

-   start with a summary line of max 50 characters

    To achieve the character limit, **don't** use `-m`, and edit the message in Vim.

    The initial line should:

    - be in the imperative, e.g., `Make` instead of `Made`.
    - start with a capital letter.
    - end with a period.

    The first line is treated specially by many tools which makes that line even more preeminent,
    e.g., Git itself has `git log --oneline`. So make that line count.

-   blank line

-   detailed explanation of the non-trivial changes.

    In practice, commits rely on the pull request or fixed issue description for the extended information.

E.g. of good commit message:

    Add new super feature.

    The feature behaves that way on case X because without that behavior,
    case Y would fail miserably.

## amend

Instead of creating a new commit, add modifications to the last existing commit:

    git commit --amend -m 'New msg.'

Modifies history.

The best way to correct a commit before submitting a change, while keeping the change to a single commit.

To change the commit commits further in the past, use `git rebase`.

Reuse old message:

    git commit --amend --no-text

Change author:

    git commit --amend --author "Ciro Santilli <ciro@mail.com>"

To correct the name of an author on an entire repository, see:
<http://stackoverflow.com/questions/750172/how-do-i-change-the-author-of-a-commit-in-git>

## Commit all tracked files

    git add -am 'message'

Will create a new version, considering all files that are tracked (even if they were not added with add).

It is a very common default commit command.

If you use this all the time, you only add files once.

# log

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

## all

Show all commits:

    git log --all

Includes:

- on other branches besides the current (by default only current branch is shown):
- future commits when navigating history

## patch

Show every commit and diff (Patch) of a single file:

    git log -p file

# grep

Show only if grepping commit messages match:

    git log --grep 1

# n

View up to a certain number of log messages (most recent):

    git log -n 1

`-n 1` is specially useful if you want to get information on the current commit,
specially when used with `pretty=format`.

## format

The `--pretty` option allows for any output format.
There are also options which are aliases to useful formats that can be achieved with `--pretty`.

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

## graph

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

## decorate

Also show refs for each commit:

    git log --decorate --pretty=oneline

Sample output:

    abc2f322034989737e0c7654ecbeaa1009011bb6 (HEAD, normalize) Improve output normalization with custom parser.
    9b397b1d09f126aeba985aed8c41bf86ba0b0e58 Add -l option.
    9dc5a1a74d65fdb3e1d6aa23365089a0d8d7a6ed Add -n option.
    d99ce39e4c37c869ba2b98f593f31d00842c8c99 Add -s option.
    2fba1c4ba0574027fe8845aa5ce63edea677824f (up/master, origin/master, origin/HEAD, only-ext, master) Merging and resolving conflict

## simplify-by-decoration

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

## Range

    git log rev1..rev2

If any of them is omitted, it defaults to `HEAD`.
Major application: see differences between a branch and its remote.

Outdated remote origin:

    git fetch origin
    git log origin/master..

Updated upstream:

    git fetch upstream
    git log ..upstream/master

To simply count the number of different versions, consider `git branch -vv`

## diff-filter

View deleted files only:

    git log --diff-filter=D --summary
    git log --all --pretty=format: --name-only --diff-filter=D

Useful to find when you deleted a file from a repo if you don't know its exact path!

## follow

Also cross `git mv`:

    git log --follow -p file

If a merge occurs, both branches appear on `git log` and get mixed up chronologically
and it is impossible to set them apart.

## first-parent

To show only history of the current branch ignoring merges do:

    git log --first-parent

This is a great option to view history on a feature branch onto which upstream was merged from time to time.
Rebase is a better option than merge in this case if you work locally,
but may not be an option if a group is working on the feature branch.

## Reachability

Commits point to their parents (0, 1 or more), but not to their children.

This is why when the term *reachable* is used,
it implies commits which are ancestors of a given commit.

# shortlog

Summarizes log information.

Group by author, count by author:

    Aaron France (1):
        Fixed JSON description of system hook

    Aaron Stone (2):
        Tiny fix to the add/edit groups form path field
        Allow the OmniAuth provider args parameter to pass through as either an Array or a Hash.

    Abe Hassan (1):
        Fix the sigil for merge request email

See how many commits each author did:

    git shortlog -nse

# describe

Show the most recent tag reachable from current branch.

Any tag:

    git describe --tags

Only annotated tags:

    git describe

TODO understand `--abbrev`.

Very useful to check out to the most recent stable version before building:

    git checkout "$(git describe --tags --abbrev=0)"

# show

Show human readable information on various types of objects.

## View files at specific version

Show specific versions of files and other infos.

View file at an specific version, path relative to root:

    git show HEAD^:path/to/file

Relative to current directory:

    git show HEAD^:./path/to/file

Application: checkout a file with a different name:

    git show HEAD^:path/to/file > new/path/to/file

# notes

TODO

# gitk

Gitk is a GUI for git. Part of the Git source tree.

Consider tig for a very good curses version of gitk

Most of what it does can be done better from the git the command line interface, except for:

- visualizing the commit tree, since this requires lines too fine for a terminal.
- look at the log for interesting changes, then click on a potentially interesting change to see its diff.

All of the above are also possible via curses based tig.

What you almost always want is to use with `--all` to see all branches marked:

    gitk --all

## diff-index

Plumbing.

Compares blobs between index and repository.

## diff-tree

Plumbing.

## diff-files

Plumbing.

Compares files between the working tree and the index.

## raw diff format

A raw diff is a summarized diff output format that only shows file level modifications,
not changed lines. It also shows the similarity index for renamed files.

It can be viewed with `git diff --raw`, or as the output of the diff plumbing commands.

The format is documented at `man git-diff-index`.

# Revision

A revision is the git name for a version. It is also known informally as a commit.

## How to name revisions

To actually go to another version, you have to be able to tell git which one is it,
so that git can go back to it.

For the manual see:

    man gitrevisions

There are a two ways to do that:

- SHA-1 hash
- refs: names that points to SHA-1 hashes

### SHA-1

### Hash

This is the SHA hash of the entire repo.

If you don't know what a SHA hash is learn it now. <http://en.wikipedia.org/wiki/SHA-1>.
The key properties of a SHA functions are that:

- it is very unlikely that two inputs give the same output.
- small changes in the input make large unpredictable changes on the output.

In this way, even if SHAs contain much less information than the entire repository itself (only a few bytes),
it is very unlikely that two different repositories will have the same SHA.

The SHA input includes things like file contents, commit timestamps, authors and tags.
Therefore, even if the files are the same, SHAs will probably be different.

The most complete is giving the entire hash, so:

    1ba8fcebbff0eb6140740c8e1cdb4f9ab5fb73b6

Would be version 2.

If this is the only version that starts with `1ba8fc` or `1ba8`,
you could use those as well. 6 digits is common for manual use.

Get the hash of the latest commit:

    git log -n1 --pretty=format:%H

#### Well known SHA-1s

All zeros: `'0' * 40`. Indicates a blank object, used on the output of many commands
as a placeholder when something is deleted or created.

Empty file:

    printf '' | git hash-object --stdin
    e69de29bb2d1d6434b8b29ae775ad8c2e48c5391

Empty tree: <http://stackoverflow.com/questions/9765453/gits-semi-secret-empty-tree>

### Reference

### Refs

### pack-refs

Refs are names that point to SHA-1 hashes, and therefore to revisions.

There are many types of references.

Most of them are represented in in files under `.git/refs/` which contain only the SHA they point to. E.g.:

-   *branches* like `master`:                 by default at `.git/refs/heads/master`,    modified by `git branch`, `git fetch`, etc.

-   *tags* like `1.0.1`:                      by default at `.git/refs/tags/1.0.1`,      modified by `git tag`.
    Point to the SHA of the tag object, not the commit.

-   *remote* branches like `remotes/feature`: by default at `.git/refs/remotes/feature`, modified by `git fetch`.

If a ref is not found there, it is also searched for on the `.git/packed-refs`:
this can be more space efficient since each file has metadata associated to it.
The `git pack-refs` command helps to optimize the repository by putting more refs
in the files `packed-refs` file.

But there are also some special ones like `HEAD` which live outside of of `refs`, at: `.git/HEAD`.

TODO how to create refs outside those subdirectories? GitHub creates under `.git/refs/pull` for e.g..

Although refs live in subdirectories of `refs`, you don't usually need to specify the subdirectory:
just saying `master` is often enough to specify `refs/heads/master`.
Git uses the following search order, documented at `man gitrevisions`:

-   `$GIT_DIR/<name>` Usually useful only for special branches like
    `HEAD`, `FETCH_HEAD`, `ORIG_HEAD`, `MERGE_HEAD` and `CHERRY_PICK_HEAD`.

-   `refs/<name>`

-   `refs/tags/<refname>`

-   `refs/heads/<name>`

-   `refs/remotes/<name>`

-   `refs/remotes/<name>/HEAD`

#### HEAD

The `HEAD` is the current commit we are on.

Lives at `.git/HEAD`.

It is possible to determine the current `HEAD` by doing `git branch`:
the head will be the branch with an asterisk in front of it.

Internally, the head is determined by the content of the file `$GIT/HEAD`,
which is the hash of the current head commit.

##### Example: HEAD

Start with [1]. We have:

    (1)
     |
     HEAD

After another commit:

    (1)-----(2)
             |
             HEAD

After another commit:

    (1)-----(2)-----(3)
                     |
                     HEAD

#### ORIG_HEAD

`man gitrevisions` says:

> ORIG_HEAD is created by commands that move your HEAD in a drastic way, to record the position of the HEAD before their operation, so that you can easily change the tip of the branch back to the state before you ran them.

`git reset --hard` is a drastic change, and `man git-reset` says that `ORIG_HEAD` is created on that operation.

So you can just redo the last `reset --hard` as:

    git reset --hard something
    git reset --hard ORIG_HEAD

### show-ref

Low-level references listing:

    git show-refs

Sample output:

    9b7dd8b4c04c427de22543fec7f52be26decdb22 refs/heads/up
    861fa5553de736af945a78b4bf951f6f5d2618e9 refs/remotes/mine/zz/public-user
    9b7dd8b4c04c427de22543fec7f52be26decdb22 refs/remotes/origin/master
    52d771167707552d8e2a50f602c669e2ad135722 refs/tags/v1.0.1

### update-ref

Low-level reference manipulation.

### Relative to another revision

One commit before:

    HEAD~

Two commits before:

    HEAD~~
    HEAD~2

Three commits before:

    HEAD~~~
    HEAD~3

Also work:

- hash:        `1ba8f~3`
- branch:      `master~3`
- tag:         `1.0~3`
- remote head: `origin/master~3`
- the previous position of branch `master`: `master@{1}`

Moving forward is not unique since branch can split and have multiple children,
so it is more complicated.

## name-rev

If you have the hash of a commit and you want a symbolic name for it,
`name-rev` does that for you, probably looking for the closest named reference ahead of the commit.

Example:

    git name-rev 012345

Sample output:

    012345 master~2

Example:

    git name-rev HEAD

Sample output:

    012345 some-branch

## symbolic-ref

    git symbolic-ref 'master2' 'refs/heads/master'

## commit-ish

## tree-ish

## rev

The terms:

- `<commit-ish>`
- `<tree-ish>`
- `<rev>`

are used on command specifications throughout Git, so it is crucial to grasp their meaning.

`<commmit-ish>` is a name that ultimately resolves to a commit, e.g.:

- directly: the SHA-1 of the commit
- indirectly: a tag that points to a commit

Most of the naming described a `man gitrevisions` are commit-ishes.

`<tree-ish>` is a name that ultimately resolves to a tree, which `man gitrevisions`
defines as either a directory or a file (blob). Every commit-ish is also a tree-ish
that refers to the top-level tree of the commit, but a few tree-ishes are not commit-ishes, e.g.:

- master:path/to/tree
- SHA-1 of a tree object

TODO `<rev>` vs `<commit>` vs `<commit-ish>`?

# diff

View diff between working tree and index (changes will disappear after `git add`):

    git diff

View staged differences (git added) and `HEAD`:

    git diff --cached

View differences between two revisions:

    git diff eebb22 06637b

For a single file:

    f=
    git diff -- "$f"

Ignore whitespace only changes (e.g. indent changes):

    git diff -w

Ignore changes when a file is moved to another name:

    git diff -M

This can be auto detected even before staging with `git mv` when files are exactly the same.
It is also possible to consider moves up to a percentage of similarity via `-M90`.

Show only how many lines were added / removed from each file, and the order of addition/removal:

    git diff --stat

Sample output:

    app/assets/javascripts/extensions/array.js                  |  2 +-
    app/assets/javascripts/groups.js.coffee                     |  2 +-
    app/assets/javascripts/markup_preview.js.coffee             | 39 +++++++++++++++++++++++++++++++++++++++
    app/assets/javascripts/notes.js.coffee                      | 74 +++++---------------------------------------------------------------------
    app/assets/javascripts/profile.js.coffee                    |  2 +-
    app/assets/stylesheets/g
    spec/seed_project.tar.gz                                    | Bin 9833961 -> 9789938 bytes

Show only how many file changed, and how many additions deletions were there:

    git diff --shortstat

Sample output:

    40 files changed, 244 insertions(+), 203 deletions(-)

View only changed words:

    git diff -M

## color-words

## word-diff

    git diff --word-diff

Sample output:

    The [-gud-]{+good+} word.

colored if you have `--color`.

Show only color, very neat:

    git diff --word-diff=color

Same as:

    git diff --color-words

Sample output:

    The gudgood word.

where `gud` is red and `good` is green.

`diff-highlight` is a related contrib script.

## Diff format

Sample output:

    @@ 3,2 3,3 @@
     before
    +error
     after

Meaning:

-   before, line 3 was `before`, line 4 `after`.

    There were 2 lines total in what we see.

-   after, `error` was added after `before`, becoming line 4

    There will be 3 lines total in what we see.

    `+` indicates that a line was added.

    Not surprisingly, if we remove something, a `-` will show instead

After a `git merge`, in case of merge conflicts,
`git diff` shows a special mode that shows diffs to both parents:

    +     Added in theirs
    +     Added in theirs2
     -    Removed in ours
    ++    Added in both
     +    Added in ours

## Newline at the end of file

If the file does not end in a newline, you will see things like:-

Add `a` without newline at end of file:

    +a
    \ No newline at end of file

Add `\n` at end of file that had no ending newline:

    -a
    \ No newline at end of file
    +a

This way, every line that starts with `+` is assumed to have a newline at the end,
unless stated otherwise.

Beware of editors that do magic things with ending newlines: someday it may bite you.

For example, Vim 7.3 hides trailing newlines by default.

`tail file | hd` and `truncate -s -1` will never lie to you.

## Side-by-side diff

Not possible natively: you must use `git difftool`.

With `difftool`, one option seems to be: <https://github.com/ymattw/cdiff>

# difftool

Use configured `diff` tool so see the diff.

# tag

Tags are a type of ref: names for commits commits.

They live under `.git/refs/tags`.

Difference from branches

-   tags don't move automatically with commits, so you can refer to a commit forever by its tag,
    unless an evil developer changes the tag, which should almost never be done.

-   tags occupy a single namespace: there is no `remotes`. As a consequence,
    you have to be very careful with which tags you push to a remote
    so as to not overwrite other people's local tags.

Typical usage: give version numbers: `1.0`, `1.1`, `2.0`

    ./copy 2

You cannot give a tag twice:

    git tag 1.0
    git tag 1.0 HEAD~

So you must delete the old tag before.

A single commit can however have multiple tags.

## Annotated tag

There are two types of tags, annotated and lightweight (not annotated).

Annotated tags have an associated message, author and creation date.

For internals and when to use see: <http://stackoverflow.com/a/25996877/895245>

Annotated tags are tags that point to tag objects that point to commits.

Because of this, they have more metadata than just the commit they point to,
including a message (possibly with a GPG signature at the end if you use `-s`)
and tagger identity and timestamp.

Use annotated tags to all tags you will publish,
e.g. version numbers as they contain more useful information.

Some commands treat annotated and lightweight tags differently.
The general semantics of such differentiation suggests the following rule,
which you should always follow:

> use lightweight tags only for quick and dirty private development tags.

-   `git describe` goes back to the first annotated tag ancestor,
    not lightweight, by default.

    Therefore, `git describe HEAD` will always go the latest stable version
    if you follow the above convention, even if you have private development only tags.

-   `git push --follow-tags` only pushes annotated tags.

Create annotated tag to `HEAD`:

    git tag -a 2.0 -m 'message'

The message is mandatory: if not given an editor will open up for you to type it in.

## List tags

Get a newline separated list of all tags for the latest commit, or empty if no tags are available:

    git tag --contains HEAD

Sample output:

    tag1
    tag2

## Create tags

Give lightweight tag to `HEAD`:

    git tag 2.0

View associated information of annotated tag:

    git show 2.0

Give tag to another commit:

    git tag 1.0 HEAD~

Give another tag to that commit:

    git tag 1.1 HEAD~

## Get tag info

List all tags:

    git tag

Sample output:

    1.0
    1.0a
    1.1

List tags and corresponding hashes side by side:

    git show-ref --tags

List with tags with corresponding commit messages side by side: not possible without a for loop:
<http://stackoverflow.com/questions/5358336/have-git-list-all-tags-along-with-the-full-message>

List tags with date side by side and on commit tree:

    git log --date-order --graph --tags --simplify-by-decoration --pretty=format:'%ai %h %d'

## Edit tag

Strictly speaking there is no tag editing,
only overwriting tags with new ones of the same name:

    git tag -f tagname
    git tag -af -m tagname

This requires the `-f` flag or else the command fails.

## Delete tags

Delete a tag:

    git tag -d 1.0

## Push tags to remote

By default `git push` does not push tags to the remote.

The sanest way is to push explicit tags:

    git push <remote> <tagname>>

Another sane option introduced around 1.8 is:

    git push --follow-tags

which only pushes annotated tags that can be reached from the newly pushed commits.

Push all tags with:

    git push --tags

but this is bad because it might push unwanted development tags,
which could conflict with the local tags of other developers.

Delete a remote tag with either of:

    git push --delete tagname
    git push :tagname

## Get tags from remote

`clone` automatically gets all the tags.

`fetch`:

-   by default gets all tags that point to objects that exist on the local repository.
    Does not overwrite existing tags.

-   with `--tags` fetches all tags and overwrite if existing locally.

    When overwriting shows a message like:

        - [tag update]      tagname          -> tagname

-   `git fetch tag` fetches only a single tag

## describe

Get the most recent annotated tag reachable from a given commit. Defaults to `HEAD`:

    git describe

Sample output:

    v6.4.0.pre2-16-g41ae328

Format:

    <tag>-<commits_ahead>-g<hash_start>

Not necessarily annotated tag:

    git describe --tags

If you want to use this programmatically you could:

    git describe --abbrev=0 --tags 2>/dev/null

Which ignores the error message in case there are no tags,
so you get an empty result if there are no tags, and the latest tag if there is at least one tag.

# branch

Branches are a type of ref: a name for a commit.

Branches live under `.git/refs/heads`.

Unlike tags, branches are movable: when you commit on a branch the branch moves.
Therefore, you cannot refer to a single revision forever with a branch.

Branches are used to creates alternate realities
so you can test changes without one affecting the other.

## master

`master` is the name of the branch created by default on new repositories.

There is nothing else special about it.

By convention, In many work flows,
it represents the most recent unstable version of the software,
so it is where you will develop the software.

There are also some work flows that only leave stable versions at `master`,
and develop on the `dev` branch.

## List branches

    git branch

Not the asterisk indicating which is the current branch.

More info:

    git branch -v

Also shows start of SHA and last commit message:

    api-attach   7dc296b Update note attachment from API.
    api-username 35da7b8 API get user by username.
    demo         9c1aebe Marked markdown preview as you type.

One very important way is to do is graphically:

    gitk --all

Will show you who is the descendant of whom!

## Create a branch

The most common way to create a branch is via:

    git checkout -b branchname

which already sets that branch as the current.

Create a branch without setting it to current:

    git branch branchname

## What happens when you create a branch

To the files, nothing.

To the tree, suppose we are [1u]

Then after:

    git branch b

It becomes:

    (1)
     |
     master *
     b

## What happens to a branch when you commit

The *current* branch moves forward and continues being current.

Ex: start at [1ub](#1ub) now:

    git add c
    git commit -am 'c'

Gives:

    (1)-----(c)
             |
             master *

Now try:

    git checkout b

Which gives:

    (1)-----(2)
     |       |
     b *     master

C disappears because it was not tracked in `b`:

    ls
        #a b
    echo c1 > c
    git add c
    git commit -m 'cb'

And now we have:

    +---------------(cb)
    |                |
   (1)-----(2)       b *
            |
            master

Which makes it obvious why a branch is called a branch.

## Detached head

Is when you checkout to a commit that has no branch associated.

E.g.: start with [2]

    git checkout HEAD^

Now see:

    git branch

Shows current branch as:

    (no branch) *

### What should I do if I want to branch from the detached head

If you are on it, you should first create a branch:

    git branch b

Then work normally.

You can also create a branch before going to it with:

    git branch <hash>

### What happens if I commit on a detached head

Bad things! Never do this!

Git does commit, but stays on a undefined state.

To correct it you can create a branch:

    git branch b

And since you were on no branch, git automatically changes to `b`.

#### What if I commit and checkout

Worse things.

Your old commit still exists, but does not show even on `git log --all`.

Git warns you: this might be a good time to give it a branch, and you should as:

    git branch b hash

## Set branch commit

You can also create a branch at any commit other than the current one:

Take [2]

    git branch b HEAD~

Now

    git branch -v

To create switch to it directly:

    git checkout -b b HEAD~

## Slash in branch name

Inside the `.git`, branches are placed under `refs`.

If you name a branch `a/b` it will create a file under `refs/a/b`.

Therefore you can't both:

- have a branch named `a`
- have a branch names `a/b`

since `a` would have to be both a directory and a file at the same time for that to work.

## Rename branch

Rename a given branch:

    git branch -m oldname newname

Rename the current branch:

    git branch -m newname

## Branch without parent

If two repositories are strictly linked,
it is possible to use a single repository with unrelated branches for both.

To achieve this, you must create a branch without a parent, which can be done with:

    git checkout --orphan branchname

This command takes the tree:

    ( )-----( )
             |
             master *

and generates:

    ( )-----( )
             |
             master *

    ( )
     |
     branchname

This is notably the case of GitHub Pages which requires an orphan branch called `gh-pages`.

Before you do this however, take into account its downsides:

- you cannot view file from both branches simultaneously (unless you copy the repository)
- its more confusing for new users

# check-ref-format

Plumbing command to check if a `ref` is a valid name.

Git imposes several restrictions on `refs`, such as not containing spaces,
even is those don't have a specific technical reason like name a conflict,
e.g. no spaces: <http://stackoverflow.com/questions/6619073/why-cant-a-branch-name-contain-the-space-char>

On the other hand, except for the small restriction list, UTF-8 names are allowed.

TODO why does:

    git check-ref-format 'master'

fail, but:

    git check-ref-format --branch 'master'

pass? What does the first form do?

# checkout

Goes to another version

Before you go to another version, you must see which versions you can go back with `log` or `gitk`.

## Entire repo

Use the `checkout` command with some version name as explained in [Revisions](#revisions) for example:

    git checkout 494b
    git checkout HEAD~
    git checkout master~

The command is called `checkout`, because we are going to "check out" what another version was like.

If you checkout the entire repo, `HEAD` moves!

If you omit the version, defaults to `HEAD` so:

    git checkout
    git checkout HEAD

Are the same.

## To previous branch

    git checkout -

which is the same as:

    git checkout @{-1}

### Example: checkout entire repo

Start with [3].

It looks like this:

    (1)-----(2)-----(3)
                     |
                     master
                     HEAD

Now do:

    git checkout HEAD~~

The files `a` and `b` now both contain one line!

    cat a
        #a1

    cat b
        #b1

The tree looks like this:

    (1)-----(2)-----(3)
     |               |
     HEAD            master

Note how the `HEAD` moved, but `master` did not!

Now do:

    git checkout master

And `a` and `b` contain three lines again. This is how things look:

    (1)-----(2)-----(3)
                     |
                     master
                     HEAD

    cat a
        #a1

    cat b
        #b1

Files that are not tracked stay the same.

### Untracked files

Start with [2]

    echo -e 'c1\nc2' > c

Now checkout:

    git checkout HEAD~

`a` and `b` have changed

    cat a
        #a1

    cat b
        #b1

But the untracked `c` stays the same:

    cat c
        #c1
        #c2

### Uncommitted changes

If you have not yet committed changes, git warns you and does not checkout.

#### Checkout uncommitted modification

Start with [2].

    echo a3 >> a

Then try:

    git checkout HEAD~

Git says that there is a change, and does nothing.

#### Checkout file overwrite

Start with [2]

    git rm a
    git commit -am '-a'

    git echo -e 'a1\na2' > a

Then try:

    git checkout HEAD~~

This fails again, because file a would be overwritten, even if its contents did not change.

## Single file or dir

Just like checking out the dir, but you also specify the files:

    git checkout HEAD~ a b

The head does not move now! This is different from the behaviour of checking out without a path.

New files that appear are just like untracked ones.

### Checkout single file

Start from [2]:

    git checkout HEAD^ a

    cat a
        #a1

But we are still at master:

    git branch
        #* master

### Checkout single removed file

Start from [2]

Remove b and commit:

    git rm b
    git commit -am '-b'

Now restore it:

    git checkout HEAD~ b

    cat b
        #b1
        #b2

The file must exist in the version you want to checkout to.

### Checkout after remove

    start with [1]

    git rm a
    git commit -am 'noa`

Now try:

    git checkout a

Which is the same as:

    git checkout HEAD -- a

And it fails, because in `HEAD` a was removed from the repo.

### Uncommitted changes

Unlike when checking out the entire repo, Git does not prompt you
in case of non-committed modifications when checking out individual files!

This is a great way to achieve data loss.

### Example: checkout single file with modifications

Start from [2]

    echo a3 >> a
    git checkout

# bisect

Checkout interactively to binary search between two commits for an error.

Given:

    (A)---(B)---(C)---(D)---(E)

When you:

    git bisect start
    git bisect bad
    git bisect good A

It will checkout to `C`, you will test the program. If it fails, you will do:

    git bisect bad

And if it works:

    git bisect good

And the binary search continues!

# bisect run

<http://stackoverflow.com/questions/4713088/how-to-use-git-bisect/22592593#22592593>

# stash

Saves all unstaged modifications of the working tree,
and returns the working tree to `HEAD` into a modification stack called *stash*.

The changes can be applied to any branch afterwards.

This is a common operation when:

- you are working on a branch, when a more urgent branch needs fixing,
    but you don't want to create a commit just to save the current state
- you want to apply working tree modifications to another branch

Push changes to the top of the stash:

    git stash

List stash:

    git stash list

Apply change at the top of the stash:

    git stash apply

# merge

Is when you take two branches and make a new one that is child of both.

## Merge strategies

Git attempts to merge automatically using one of different merge strategies.

Some strategies may require user intervention, while others never do.

Some important strategies are:

-   `ours`: keeps local changes

        git merge -s ours ref

    Can be used on more than 2 branches.

-   `theirs`: keeps remote changes. Must be used with `-X` instead of `-s`, as discussed at:
    <http://stackoverflow.com/questions/173919/git-merge-s-ours-what-about-theirs>

        git merge -X theirs ref

    Can be used on more than 2 branches.

-   `octopus`: able to merge more than 2 branches, but only if there are no conflicts.

    The generated commit will have multiple parents. E.g.:

           +--B
           |
        A--+--C
           |
           +--D

    Then:

        git checkout B
        git merge -Xoctopus C D

    Gives:

           +--B--+
           |     |
        A--+--C--+--E
           |     |
           +--D--+

### Recursive merge strategy

The default strategy.

Uses the `diff3` merge algorithm recursively.

The `diff3` algorithm takes 3 file versions as input: the base, and the two conflict heads.

If there is a single common ancestor for the conflict heads, it is the base.

If there are multiple, it recursively creates a new tree TODO details,
leading up to a new virtual branch that will be the base.
`man git` says that this tends to lead to less merge conflicts than directly using either ancestor.

E.g., start with:

    (A)----(B)----(C)-----(F)
            |      |       |
            |      |   +---+
            |      |   |
            |      +-------+
            |          |   |
            |      +---+   |
            |      |       |
            +-----(D)-----(E)

Then:

    git checkout E
    git merge F

There are 2 best common ancestors, `C` and `D`. Git merges them into a new virtual branch `V`,
and then uses `V` as the base.

    (A)----(B)----(C)--------(F)
            |      |          |
            |      |      +---+
            |      |      |
            |      +----------+
            |      |      |   |
            |      +--(V) |   |
            |          |  |   |
            |      +---+  |   |
            |      |      |   |
            |      +------+   |
            |      |          |
            +-----(D)--------(E)

Example why it is a good choice: <http://codicesoftware.blogspot.com/2011/09/merge-recursive-strategy.html>

## Conflicts

## Merge conflicts

Certain modifications can be made automatically,
provided they are only done on one of the branches to be merged:

- given line of non-binary file modified
- file added
- mode changed

If all merges can be done automatically, then you are prompted for a commit message
and the current HEAD branch advances automatically to a new commit.
This type of simple merge is called fast-forward.

### Text conflicts

If a conflict happens happens on two regular text files `git merge` outputs either:

    Auto-merging path/to/file.md
    CONFLICT (content): Merge conflict in path/to/file.txt

if the file existed already, or:

    Auto-merging path/to/file.md
    CONFLICT (add/add): Merge conflict in path/to/file.txt

if two different files with the same path were created in the different branches.

The file on the working tree is modified to contain:

    <<<<<<< HEAD
        config.password_length = 1..128
    =======
        config.password_length = 8..128
    >>>>>>> other-branch

and if you do `git status` you will either of:

    both modified: path/to/file.txt
    both added: path/to/file.txt

To finish the merge you have to look into each file with a conflict,
correct them, `git add` and then `git commit`.

To put the file into one of the two versions, you can do either:

    git checkout --ours filename
    git checkout --theirs filename

This is the most common solution for binary file conflicts.

To go back to the merge conflict version with the `<<<<<< HEAD` markers you can do:

    git checkout -m filename

See both branches and the base in a merge marker style:

    git checkout --conflict=diff3 filename

The file then becomes:

    <<<<<<< ours
    int a = 1;
    ||||||| base
    int a = 0;
    =======
    int a = 2;
    >>>>>>> theirs

and `git diff` automatically shows a special diff mode called *combined diff* as:

    ++<<<<<<< ours
     +int a = 1;
    ++||||||| base
    ++int a = 0;
    ++=======
    + int a = 2;
    ++>>>>>>> theirs

In the case of `add/add` the base will be empty:

    <<<<<<< ours
    int a = 1;
    ||||||| base
    =======
    int a = 2;
    >>>>>>> theirs

TODO: possible to `git checkout --base`?

Stop the merge resolution process and go back to previous state:

    git merge --abort

### Binary conflicts

Git does not do anything smart in the case of binary files:
it is up to you to use the right tool to view the file and edit it to work.

You can use `checkout --ours` and `checkout --theirs` normally,
`checkout --conflict=diff3` does not modify the file tree and outputs:

    warning: Cannot merge binary files: conflict/binary-preview.png (ours vs. theirs)

### Permission conflicts

#### Directory file conflict

Appears as `CONFLICT (file/directory)` on `git merge`, and `both added` on `git status`, 

If a file is changed into a directory with the same name, the working is left as:

    dir-path
    dir-path~other-branch

from the side that contains the directory, or:

    dir-path
    dir-path~HEAD

from the side that contains the file.

If `dir-path~other-branch` already exists,
another names is chosen from the first free name amongst:

    dir-path~other-branch_0
    dir-path~other-branch_1
    ...

`--ours` and `--theirs` are half broken since you cannot do `git checkout --ours dir-path`
to the side that contains the directory: you have to reference the files it contains.

`--conflict=diff3 -- path` fails with:

    error: path 'conflict/perms-dir' does not have all necessary versions

#### Symlink file conflict

Appears as `CONFLICT (add/add)` on `git merge`, and `both added` on `git status`,
i.e., indistinguishable from regular file conflicts.

On the working tree, the file is always a regular file.

`--ours` and `--theirs` work as expected.

Depending from which side you do `--conflict=diff3` it may generate a symlink
pointing to a file path with conflict markers!

## Merge target branch

<http://stackoverflow.com/questions/3216360/merge-update-and-pull-git-branches-without-using-checkouts>

It is not possible to `git merge` into a target branch other than the current
because if there were merge conflicts there would be no way to solve them.

If it is just a fast forward, you can use `fetch` instead:

    git fetch origin master:target-branch

## Ignore certain files on merge

Run:

    `git config merge.ours.driver true`

and use a `.gitattributes` as:

    file_to_ignore merge=ours

## squash

Create a single commit on top of the current branch,
such that the new commit contains exactly what would be the contents of the merge.

Given:

    (A)----(B)----(C)
            |      |
            |      master *
            |
            +-----(D)-----(E)
                           |
                           feature

After:

    git checkout master
    git merge --squash feature

We get: TODO does the new commit have multiple parents?
Is the author of the feature credited in the `log`?

    (A)----(B)----(C)-----(F)
            |              |
            |              master *
            |
            +-----(D)-----(E)
                           |
                           feature

## Programmatically check if mergeable

<http://stackoverflow.com/questions/501407/is-there-a-git-merge-dry-run-option>

## Resolve merge conflicts

To resolve merge conflicts, you have to `git add file`.

There are several techniques that help you to find what is the correct resolution.

-   `git diff topic...master`: show only changes that happened on `master` after `topic` branched out,
    and which are therefore the cause of the conflict. Useful, since usually you know what
    you have changed, and you need to know what others have changed since.

    This is specified in `man git-diff`. The notation resembles that of commit sets,
    of `man gitrevisions`, but this is a special since diff operates two commits,
    not commit sets.

-   `mergetool` open an external conflict resolution tool, possibly GUI

# merge-file

Plumbing command that runs a 3-way merge on the three given input files.

It is therefore a subset of the more complex `merge` recursive operation, which generates
all the required files by checkout and runs on all required files.

# merge-base

Plumbing command that finds a best common ancestor commit between two candidates,
thus suitable for a 3-way merge.

A common ancestor is better than another if it is a descendant of the other.

It is possible to have multiple best common ancestors.
For example, both `C` and `D` are best common ancestors of `E` and `F`:

    (A)----(B)----(C)----------(D)
            |      |            |
            |      |            |
            |      |            |
            |      +-----(E)    |
            |             |     |
            |             |     |
            |             |     |
           (F)------------+-----+

Output all merge bases with `-a` instead of just one:

    git merge-base -a E F

# mergetool

Start running a conflict resolution tool,
typically a 3-way merge tool to solve all merge conflicts
for the merge the is currently taking place:

    git mergetool -t vimdiff
    git mergetool -t kdiff3

Resolve conflicts on a single file:

    git mergetool -t kdiff3 -- file

Git already knows about certain tools, and you must choose amongst them.

Git checks out all necessary versions in current directory with basename prefixes,
and calls the merge tool on them.

If the tool is not given, Git uses:

- `git config --global merge.tool kdiff3` configuration option tool
- a suitable tool found in the path

## prompt

Before opening the merge tool, by default git prompts you to enter a key to open it.

To avoid that use either:

    git config --global mergetool.prompt false

or for a single invocation:

    git mergetool -y

## keepBackup

Git generates 3 temporary files which it passes to the 3-merge tool for each conflicting file:

- the parent, before conflicting changes were made
- each conflicting child

You then have to save the output on the merge resolution tool.

After the merge, Git keeps by default the original file with the conflict markers
with a `.orig` extension.

To prevent that, do:

    git config --global mergetool.keepBackup false

# Email patches

Tools only used in projects that exchange patches via email, not in those that use web interfaces like GitHub.

## format-patch

Generate a patch to send by email.

Generate a patch from last commit:

    git format-patch HEAD~

## Signed-off by

Extra text added to commit messages or only to patches.

Required by certain projects, notably the Linux kernel, because of legal reasons:
<http://stackoverflow.com/questions/1962094/what-is-the-sign-off-feature-in-git-for>

Has no relation to GPG signatures.

Add signed-off by line to the commit message:

    git commit -ms 'Message.'

This would generate a commit message like:

    Message.

    Signed-off-by: Super Developer <super.dev@gmail.com>

Normally you don't need to pollute the commit message:
just add it to the patch sent by email:

    git format-patch -s

## am

TODO

## apply

TODO

# push

Makes changes on a bare remote repo.

The other repo can be on an external server like GitHub, or on your local filesystem.

Typical changes possible with push:

- put branches there
- remove branches from there

The full form of the command is:

    git push <remote> +<src>:<dst>

As a concrete example:

    git push origin +master:dev

but there are (sensible) defaults for almost every part of the command,
many of which are controlled by options. Also, there were major configuration
and documentation updates on 2.0, So brace yourself!

The full form, pushes the local branch `<src>` to remote with the name `<dst>`.
It `<dst>` does not exist it is created.

`+` is optional the same as `-f`: if given allows non-fast-forward updates,
thus allowing you to lose commits on the remote.

## Omit dst

    git push <remote> <src>

is the same as:

    git push <remote> <src>:<src>

## Omit src

    git push <remote> :<dst>

deletes the branch `master` on the remote.
The mnemonic is `<src>` does not exist, so you replace the remote with nothing.

Later versions of git added the saner `--delete` option which does the same thing:

    git push --delete <remote> <dst>

## Omit src and dst

    git push <remote> :

Does a matching push: pushes all branches which track on `<remote>`
for which a branch with the same name exists on `<remote>`.

## refspec

The name of the `+local-name:remote-name` argument to `git push`,

Term also used by commands such as `pull` and `fetch`.

## omit refspec

What happens on:

    git push <remote>

depends on the `push.default` option, documented under `man git-config`:

-   `matching`: same as `git push <remote> :`. Default before 2.0.
                Insane because it does a mass update operation by default!

-   `upstream`: push the current branch to its upstream branch.

-   `simple`:   like `upstream`, but don't push if the remote branch name
                is different from the local one: you need en explicit refspec for that.
                Default starting on 2.0.

-   `current`:  push the current branch to a branch of the same name.
                Simple, explicit and does not depend on any configuration.

-   `nothing`:  do nothing. For those overly concious with safety.
                Forces you to always use the branch name explicitly.

## Omit the remote

### Before 2.0

    git push

is the same as:

    git push <remote>

where `<remote>` is:

- the tracking remote of the current branch if it has one
- `origin` otherwise

The sanest configuration for the GitHub workflow:

-   let `origin` be the clone, `up` the upstream.

-   push the first time with `git push -u origin`, and further pushes just with `git push`

-   fetch and pull with `git fetch up`

    This longer form (with explicit `up`) seems unavoidable before Git 2.0
    if we want to be able to do just `git push`, which is a more common operation
    than `fetch` and thus should be the shorter one.

### After 2.0

More configuration variables were added. The search order is:

- `branch.<name>.pushremote`
- `remote.pushdefault` (affects all branches)
- `branch.<name>.remote`
- `origin`

The sanest configuration for the GitHub workflow:

-   let `origin` be the upstream, `mine` the clone.
-   let `remote.pushdefault` be `mine`
-   now you can both fetch and push directly with `git fetch` and `git push`

## u

## Upstream

## Tracking branch

Each local head can have a remote branch to which it pulls and pushes by default,
which is known as it's upstream.

The upstream is set under the `branch.<name>.remote` configuration.

Note that for `push`, other configurations come into play after Git 2.0,
in particular `remote.pushdefault` and `branch.<name>.pushremote`, so the
concept is more strongly related to fetching.

Push and also set the upstream of current branch:

    git push -u remote branch

Set the upstream without push for current branch:

    git branch --set-upstream remote branch

Get a list of all upstreams:

    git branch -vv

Also shows the very useful ahead behind statistic on the tracked remote.

There seems to be no clean plumbing way to get the corresponding upstreams
of all branches programmatically without grepping:
<http://stackoverflow.com/questions/4950725/how-do-i-get-git-to-show-me-which-branches-are-tracking-what>

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

Modify current remote branch:
<http://stackoverflow.com/questions/1485578/how-do-i-change-a-git-remote-head-to-point-to-something-besides-master>

After you delete remote branches, you can remove the local tracking branches with:

    git remote prune origin

# remote

Manage remote repositories.

When you clone something, it already has a remote called `origin`.

Remotes are short names that point to URLs. They are stored under `.git/config` as:

    [remote "<remote-name>"]
      url = http://github.com/user/repo

There are also other remote related variables configurations
that can be stored under `[remote]`, in including `fetch`.

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

Remove all remote refs under under `remotes/origin`
such that their remote it tracks has been deleted:

    git remote prune origin

Useful after `push --delete` or when the remote was deleted via the web interface,
e.g. after the pull request was merged.

Also possible with:

    git fetch -p

The actual branches will still be there. Delete merged branches,
i.e. any ancestor of the current branch, with:

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

The best way is explicitly `<remote-name>/<branch-name>`
but some commands do explicit stuff if you enter just `<branch-name>`
and there is no other branch in your repo with that name.

Ex: `origin/master`, `origin/feature2`, `upstream/feature2`, etc.

### branch

Branch only sees remotes if you give the `remote-name` explicitly.

### checkout to a remote without specifying which remote

If you have a tracking branch `origin/b`, no other tracking branch of the form `some-remote/b`,
and no branch named `b`:

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

# ls-remote

List remote references:

    git ls-remote origin
    git ls-remote https://github.com/gitlabhq/gitlabhq

Sample output:

    e46b644a8857a53ed3f6c3f64b224bb74b06fd8e    refs/heads/6-9-stable
    ec8d39897c76439c71b79738c5a348b36a03753b    refs/heads/master
    4647177cb5d7d8c13f28c79a91ff2894353d25e9    refs/pull/999/head
    5de75111249e1b06a03ff140c95b49dc06f7521c    refs/pull/999/merge
    52d771167707552d8e2a50f602c669e2ad135722    refs/tags/v1.0.1
    7b5799a97998b68416f1b6233ce427135c99165a    refs/tags/v1.0.1^{}

-   `^{}` is explained in `man gitrevisions`: dereference tags until a non-tag is found
    (remember that tags can tag anything, including other tags)

-   `7b5799a97998b68416f1b6233ce427135c99165a` is the SHA-1 of the tag object

-   `52d771167707552d8e2a50f602c669e2ad135722` is the SHA-1 for the actual commit,
    which is most likely to interest you.

# URLs

# Protocols

If you can connect via SSH to a computer as:

    ssh username@host

Then you can do git operations as:

    git username@host:/path/to/repo

GitHub git repo directories always end in `.git`, but this is just a convention.
Also, in GitHub there is a single Git user called `git`.

Other methods of connection include:

-   HTTP over URLs of type `http://`. Less efficient than the Git protocol.

-   a git specific protocol with id `git://`. More efficient than HTTP since git specific,
    but also requires a more specialized server.

TODO: why does:

    cd repository
    python -m SimpleHTTPServer
    cd
    git clone localhost:8000
    git clone localhost:8000/.git

fail? Related for push: <http://stackoverflow.com/questions/15974286/pushing-to-a-git-repository-hosted-locally-over-http>

# clone

Make a "copy" of another repo.

Fetches all the remote branches.

Creates only a single branch: the branch were the `HEAD` of the remote was,
but also fetches all other branches under `.git/refs/origin/`, so that you can just
`git checkout -b other-branch` to create them.

## Example: clone and branches

Start with `multi`.

    git clone a c

Creates a repo c that is a "copy" of a. now:

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

# fetch

Looks for changes made on a remote repository and brings them in.

The full signature is:

    git fetch <remote> <refspec>

where `<refspec>` is the same as for `git push`.

You can do a dry run that only lists remote references with `ls-remote`.

For example, to update you `master` branch from a remote `dev` you can do:

    git fetch origin dev:master

This will only work for fast-forward changes, because it could be done for
any branch, not just the current one, and in that case there is no way to resolve
merge conflicts without a working tree.

## Omit refspec

Omitting refspec as in:

    git fetch <remote>

defaults `<refspec>` to:

-   `remote.<remote>.fetch`, which is set by default on remote creation to
    `+refs/heads/*:refs/remotes/<remote>/*` configuration, so a matching forced update
    from remote `heads` into local `remotes/<remote>/`.

    So after you `git fetch origin`, you can create a local branch with a shorter name
    and checkout to it with:

        git checkout -b local-name origin/remote-branch

    Remember that this works because `.refs/remotes` is in the refs search path,
    and no sane person would have a local reference called `.git/heads/origin/remote-branch`,
    or that would have the preference.

    Multiple `remote.<remote>.fetch` entries can be added.
    A possibly useful one with GitHub, is:

        fetch = +refs/pull/*/head:refs/pull/origin/*

    which also fetches all pull requests, which GitHub stores under `refs/pulls`.
    You can then checkout with:

        git checkout -b 999 pull/origin/999

    Remember that just `origin/999` won't work because `refs/pulls` is not in the refs search path.

    Also note that this configuration would might pull *a lot* of references,
    so you might be better off with one off commands like:

        git fetch origin pull/<pr-number>/head:local-name

-   `origin`

This hasn't changed in Git 2.0, and is therefore simpler than the default refspec for `git push`.

## Omit remote

Defaults the remote to the first defined of:

- `branch.<name>.remote`
- `origin`

## FETCH_HEAD

A reference that points to the latest fetched branch.

Common use case: get a single commit not on the main repository,
often on the fork feature branch of a pull request,
to try it out locally without merging or adding a new remote:

    git fetch origin pull/<pr-number>/head
    git checkout -b <local-branch-name> FETCH_HEAD

# bare

A bare repository is one that:

-   only contains files that are inside `.git`: in particular, it has no working tree nor index.

-   has `core.bare` set to `true`. This option is set automatically by commands that create repositories:
    `init` and `clone` will leave it on `false`, while `clone --bare` will set it to `true`.

    Because of this configuration variable you cannot directly push to the `.git` of a repository
    created with `git init`.

This is what GitHub stores for you: no need to store the files also!

There are some operations that you can only do/cannot do on a bare repo:

-   you can only push to a bare repo

    This means that using git to deploy a project requires a bare repository
    on the server + a post commit hook that will update the tree where desired.

-   you cannot to any operation that involves the working tree from a bare repo,
    including `pull`

To create a bare repo from scratch:

    git init --bare

To create a bare repo that is a clone of another repo:

    git clone --bare other

## Current branch

The active or current branch of a bare repository is what its `HEAD` points to.

This has the following effects:

- `clone` automatically checks out one of the branches which are on the same ref as the `HEAD`
- when deleting remotes with `git push remote --delete branch`,
    it is not possible to delete the current remote.
- it is the branch that GitHub shows by default.

It is not possible to use `checkout` on a remote branch since checkout
also acts on the working tree. You must use `update-ref` or better `symbolic-ref`:

    git update-ref   HEAD <hash>
    git symbolic-ref HEAD refs/heads/something

As of 1.8.4, there seems to be no way to conveniently change the current remote branch:
<http://stackoverflow.com/questions/1485578/how-do-i-change-a-git-remote-head-to-point-to-something-besides-master>

# pull

`pull` is exactly the same as fetch + merge on given branch and merges with current branch.

`pull --rebase` does `reabase` instead of `merge`. You need that after someone did a `push -f`.

Does not update remote heads like fetch does.

## Basic usage

State of the remote:

    (A)----(B)----(C)----(H)
                   |      |
                   |      master *
                   |
                   +-----(E)
                          |
                          feature

Your repo after a clone:

    git clone path/to/repo

    (A)----(B)----(C)----(D)
                   |      |
                   |      master *
                   |      origin/master
                   |
                   +-----(E)
                          |
                          origin/feature

New state of the remote:

    (A)----(B)----(C)----(D)----(H)
                   |             |
                   |             master *
                   |
                   +-----(E)----(F)--------(G)
                                            |
                                            feature

Local repo after a `merge`:

    git pull origin master

    (A)----(B)----(C)----(D)--------(H)
                   |                 |
                   |                 master *
                   |                 origin/master
                   |
                   +-----(E)--------(F)--------(G)
                          |                     |
                          feature               origin/feature

So you current branch `master` has been merged into the branch `master` from repo `origin`.

# Permissions

# File permissions

Git can only store a few UNIX permissions and file types.

Git uses the same data as UNIX numeric permissions to store the subset of permissions it allows:

    0100000000000000 (040000): Directory
    1000000110100100 (100644): Regular non-executable file
    1000000111101101 (100755): Regular executable file
    1010000000000000 (120000): Symbolic link
    1110000000000000 (160000): Gitlink (submodule)

It also has one special notation not present in UNIX for the Git specific concept of submodule.

There is also another permission mentioned [in the source code](https://github.com/gitster/git/blob/9d02150cf4d833935161ef265e4dc03807caa800/fsck.c#L188):

    1000000110110100 (100664): Regular non-executable group-writeable file

but a comment says that it is only for backwards compatibility, and it is only enabled if `strict` is true (TODO how to set that?). That mode is not tracked by default.

Those permissions are visible on the output of certain porcelain commands like `diff`,
so knowing them is not just internals.

Taken from: <http://stackoverflow.com/questions/737673/how-to-read-the-mode-field-of-git-ls-trees-output>

Therefore, the only permissions that can be kept are executable and group write.

TODO why is group right here and not most other permissions? Is there an important use case?

How to get around it: <http://stackoverflow.bcom/questions/3207728/retaining-file-permissions-with-git>.

The best solution seems to be the `git-cache-meta` third-party tool.

## Symlinks

Git stores represents symlinks on the same `struct` that it stores regular files except that:

- the permission is `120000` instead of `644` and `755` which are used for files.
- the content is the destination path. Note that this is not in general how symlink destinations are stored in all filesystems. E.g., ext3 stores symlinks directly in the inode, not with file contents.

On clone, git reads it's internal data in the repository,
recreates the working tree using the type of symlinks supported by the local filesystem,
just like it does for directories for example.

# Empty directories

Git ignores empty directories.

To force git to keep a dir, add a file to it.

Popular possibilities are:

- `README` file explaining why the dir is there after all. Best option.

- `.gitkeep` file. It has absolutely no special meaning for Git, but is a common convention.

# submodule

A submodule is a git repository included inside another at a version fixed by the parent.

Submodules are used to factor out directories which are used in multiple repositories.

This approach is useful when there is no way to:

- share a file between programs (like `PATH` does for executable)
- maintain different versions of a program (like `virtualenv` does for Python)

for a given technology.

If a better system does exist for you repository however,
e.g. Python / Ruby modules + virtualenv / RVM, use that method instead.

A submodule is a completely separate repo: the super repository
only keeps note of its path, URL and current commit.

## Create a submodule

Create on directory `.latex`:

    git submodule add https://github.com/USERNAME/latex.git
    git add .gitmodules
    git commit -m 'Added submodule latex.

Modifies / creates `.gitmodules`, which you should then `git commit`.

If the directory exists and contains the required git repository already, nothing is done.

Else, the repository is cloned.

Add to another directory:

    git submodule add https://github.com/USERNAME/latex.git another_name

## Submodule symlink combo

If your technology requires files to be in the current directory,
you can use symlinks into the submodule to achieve that effect.

You have a LaTeX `a.sty` file which you want to use.

- on version `1.1` for a LaTeX project 2 in `project2` repo
- on version `1.0` for a LaTeX project 3 in `project3` repo

Make a repo and put `a.sty` in the repo. Call it `latex`.

On project 2:

    git submodule add https://github.com/USERNAME/latex.git shared
    ln -s shared/a.sty a.sty

Now the dir called `shared` was created and contains your repo.

## Clone a repo that contains a submodule

To get all the files of submodules you need the `--recursive` flag:

    git clone --recursive git://github.com/USERNAME/project2.git

If you forgot to use recursive when you cloned, you should:

    git submodule update --init

It seems that making clone recursive by default is neither possible nor a good idea:
<http://stackoverflow.com/questions/4251940/retrospectively-add-recursive-to-a-git-repo>

## Update content of a submodule

    cd share
    git pull

Now from the main repository;

    cd ..
    git status
        #modified:   shared (new commits)

For your repo to incorporate this update,
you have to add the submodule path (`share/`) and commit,
or simply do a `commit -a` next time.

From the outside, the submodule looks much like a regular git controlled file.

Update the contents of all submodules:

    git submodule foreach git pull

This does not work if the modules are only listed under `.gitmodule` but have not been added to index with `add`.

## Update repository that contains as submodule

    git pull
    git submodule update

## foreach

Do an arbitrary command from each submodule directory.

Ex: updates all submodules:

    git submodule foreach git pull

Print full paths of each submodule:

    git submodule foreach pwd

## Remove a submodule

## deinit

As of git 1.8.3:

    git submodule deinit path

Files are kept and the `.gitmodule` file is not edited,
but internally the module is removed and you can get rid of those.

Before 1.8.3: first remove it from the `.gitmodules` file:

    vim .submodules

Then Remove it from `.git/config`:

    vim .git/config

Then:

    rm --cached $path_to_submodule #(no trailing slash).
    rm -Rf .git/modules/$path_to_submodule
    git commit -am 'removed submodule'
    rm -rf $path_to_submodule

## Change submodule upstream

Edit `.gitmodules` and then:

    git submodule sync
    git submodule update

## Change submodule location

<http://stackoverflow.com/questions/4604486/how-do-i-move-an-existing-git-submodule-within-a-git-repository>

# rebase

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

    (A)----(B)----(C)-------(D)
                   |         |
                   master    feature *

Therefore the rebase changes the history,
making it look linear and therefore easier to understand.

This is how you should incorporate upstreams changes on your feature branch
before you make a pull request, followed often by a squash interactive rebase.

## Interactive rebase

    git rebase -i HEAD~3

Opens up a Vim buffer where you can modify
all commits between `HEAD` and `HEAD~2` (total 3 commits).

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

`edit` can be used for example if we want to change
the commit message for `HEAD~` we edit that to:

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

If you change your mind only about a single `commit`,
but still want to change the others to:

    git rebase --skip

And we are back to `HEAD`.

Now `git log --pretty=oneline -n3` gives:

    fc95d59[...] last - 2 commit message
    81961e9[...] new last - 1 commit message
    d13a071[...] last commit message

### squash

`squash` can be used if you want to remove all trace of a commit.

`squash` is useful when you are developing a feature locally
and you want to save progress at several points in case you want to go back.

When you are done, you can expose a single commit for the feature,
which will be much more concise and useful to others,
or at least people will know that you can use `squash`.

You will also look much smarter, since it will seem
that you did not make lots of trials before getting things right.

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

Because commits `HEAD~` and `HEAD~2` will be turned into one,
it is likely that the new message will be neither of the two.

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

# replace

Magic mechanism to alter a single commit anywhere in the repository without affecting history,
(if you change a commit in the middle of the repository, it's parent SHA changes, so you have to change
it's children and so on).

Works because for every `git` command without `--no-replace-objects`
Git looks at a separate list of replacements kept under `.git/refs/replace`.

# filter-branch

Mass history rewrite using arbitrary Bash function.

Like any mass modification operations: **make a backup before you start**.

By default acts on current branch only. To act on all branches do:

    git-filter-branch [options] -- --all

Correct the name of one of the authors:

    OLD_NAME=""
    NEW_NAME=""
    NEW_EMAIL=""
    git filter-branch --commit-filter '
        if [ "$GIT_COMMITTER_NAME" = "'"$OLD_NAME"'" ]; then
            GIT_COMMITTER_NAME="'"$NEW_NAME"'";
            GIT_AUTHOR_NAME="$GIT_COMMITTER_NAME";
            GIT_COMMITTER_EMAIL="'"$NEW_EMAIL"'";
            GIT_AUTHOR_EMAIL="$GIT_COMMITTER_EMAIL";
            git commit-tree "$@";
        else
            git commit-tree "$@";
        fi' HEAD

## Committer vs author

The author is who actually wrote the commit.

The committer is who committed it on behalf of the author.

It is usually the same person in most cases, but they might differ when:

One important case where committer and author differ is in projects
where patches are generated by `git format-patch`, sent by email,
and applied by another person with `git am`. In that case,
the committer is taken from the local configuration,
while the authors comes from the patch, so nothing special needs to be done about it.

With web interfaces like GitHub, which hold all the repositories on a single machine
and apply patches with `git merge`, this is not necessary:
the commit appears directly on history, in addition to the merge commit.
This is the case for most modern projects.

# cherry-pick

Merge change introduced by given commits.

If merge is not clean, may create merge conflicts which you have to resolve similarly to `git merge`.

The existing merge messages and other metadata are kept.

Merge only the last commit from the `other-branch` branch:

    git cherry-pick other-branch

# rerere

Reuse merge strategies from previous merges.

# hooks

Take an action whenever something happens (a commit for example).

Create a hook, just add an executable file with a known hook name under `.git/hooks/`.

This executable may receive command line arguments
which Git uses to pass useful info to the executable.

Example:

    cd .git/hooks/
    echo '#!/usr/bin/env bash

    echo abc' > post-commit
    chmod +x post-commit

Now whenever you commit, you will see `abc` on the terminal!

See: <http://git-scm.com/book/en/Customizing-Git-Git-Hooks> for other hook names.

When hooks are executed on the remote they echo on the local shell as: `remote: <stdout>`.

Hooks are not transmitted on clone.

There are not global hooks. The best one can do is either:

-   set up `init.templatedir` with the desired hooks. But if you ever modify them,
    you have to modify each existing project...

-   add the `hooks` to the repository itself on a `.git-hooks` directory
    and require one extra setup action from developers. Probably the least bad option.

## PATH gotcha

Git automatically changes the `PATH` in hooks, which may lead to unexpected effects,
in particular if you rely on dependency management systems like RVM or virtualenv:
<http://permalink.gmane.org/gmane.comp.version-control.git/258454>

## pre-receive

If returns false, commit is aborted. This can be used to enforce push permissions,
which is exactly what GitLab is doing.

The stdin contains the inputs which are of the form:

    <old-value> SP <new-value> SP <ref-name> LF

e.g.:

    0000000000000000000000000000000000000000 1111111111111111111111111111111111111111 refs/heads/master

# rev-parse

Some useful commands to automate Git.

Get full path of repo root:

    git rev-parse --show-toplevel

Get relative path to the top level:

    git rev-parse --show-cdup

Path to `.git` dir:

    git rev-parse --git-dir

# rev-list

Commit tree reachability operations.

# config

Allows to get and set configuration data.

Main configuration files:

- `~/.gitconfig`: for all repos on current computer. `--global` option.

- `.git/config`: cur repo only. Takes precedence over global options.

It is a `.cfg` file of type:

    [group]
        a = b
        c = d

Corresponding command lines of type:

    group.a b
    group.c d

## Commands

List the currently used value of all non default configs:

    git config -l

Read only from the global file:

    git config --global -l

Get single value:

    git config user.name

Set value locally:

    git config user.name "User Name"

Set value globally:

    git config --global user.name "User Name"

Get multiple values: TODO

    git config --get-all user.name

Set boolean

## Most important configs with bad defaults

Non default ones that you should always set:

    # Username and email on commits:
    git config --global user.name "Ciro Santilli"
    git config --global user.email "ciro@mail.com"

    # Remember HTTP/HTTPS passwords for 15 minutes:
    git config --global credential.helper cache

    # Remember HTTP/HTTPS passwords for given time:
    git config --global credential.helper "cache --timeout=3600"

    #Let git color terminal output by default (but not if it goes to pipes,
    # or the color escape chars might break programs):
    git config --global color.ui auto

    # See grep
    git config --global grep.lineNumber true
    git config --global grep.extendedRegexp true

## Most important settings with good defaults

-   `core.pager`: pager to use. `less` by default.
-   `color.ui`: when to add color ANSI escapes. `auto` is the best option,
    which only adds the escapes if not piped.
-   `core.editor`: editor to use for commit and tag messages.
-   `core.autocrlf`: deal well with windows loved CR LF newlines.
-   `core.excludesfile`: path of a global `.gititnore` file for all projects.
-   `commit.template`: commit message template file path

### alias

Alias:

    git config --global alias.st status

Now you can use the alias as:

    git st

You can also alias to shell commands:

    git config --global alias.pwd '!pwd'

And this works:

    git pwd

It is always executed at the repo root.

This allows for the very useful combo:

    git config --global alias.exec '!exec '

Allowing you to do any command at top-level:

    git exec make

## UTF8 filenames

<http://stackoverflow.com/questions/5854967/git-msysgit-accents-utf-8-the-definitive-answers>

### quotepath

If `true`, file paths that contain characters non printable bytes are printed
as quoted C strings literals in commands, in particular UTF-8 characters
are encoded.

If `false` and the encoding is compatible with your terminal,
you will see nice characters.

So should be `false` for UTF-8 usage.

# var

Show values of Git configuration variables and all Git-specific environment variables:

    git var

Sample output:

    remote.origin.url=git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
    remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
    branch.master.remote=origin
    branch.master.merge=refs/heads/master
    GIT_COMMITTER_IDENT=Your Name <you.@gmail.com> 1410298645 +0200
    GIT_AUTHOR_IDENT=Your Name <you@gmail.com> 1410298645 +0200
    GIT_EDITOR=/usr/bin/vim
    GIT_PAGER=less -r

# gc

Tries to optimize the way git stores files internally.

Can considerably reduce the size of the repository:

    git gc

Some commands automatically run `git gc`. When this is done depends on the value of the `gc.auto` configuration.

TODO what does that do exactly? Possible use case:
<http://stackoverflow.com/questions/1072171/how-do-you-remove-an-invalid-remote-branch-reference-from-git>

# gitattributes

Configs that apply only to specific paths, not the entire repo.

It can be put:

- inside a `.gitattributes` file in the repo.
- inside the `.git/info/attributes` file.

Examples:

    *.md diff=word

Always ignore remote version of certain files on merge run:

    git config merge.ours.driver true

and then use `.gitattributes` lines like:

    path/to/file merge=ours

# Plumbing

# Porcelain

Plumbing commands are low level, porcelain are high level and more commonly used,
built upon plumbing commands.

The distinction is made on `man git` itself, which classifies commands as such.

When using Git programmatically, plumbing commands should be used instead of porcelain,
since their interface is more stable. Quoting `man git`:

> The interface (input, output, set of options and the semantics) to these low-level commands are meant to be a lot more stable than Porcelain level commands, because these commands are primarily for scripted use. The interface to Porcelain commands on the other hand are subject to change in order to improve the end user experience.

# Internals

Learn them as early as possible: they unify many topics.

Git offers lots of commands to manipulate low level internals stuff.

## .git directory

Holds all the Git information.

- `logs`: information for `reflog`.

## Objects

Very good source:
<http://git-scm.com/book/en/Git-Internals-Git-Objects>

Git implements a generic content addressable filesystem on top of your filesystem:
given the content you can find the address, which is it's SHA-1.

The main advantage of this method is that given a content like a commit you can easily determine where it will be stored
in a way that will not conflict with other objects, which are potentially create by other users.

Another advantage is that identical objects like files are all represented by a single data.

Objects are stored under `.git/objects`. There are two possible formats:

- with a filename corresponding to it's SHA-1, 40 hexadecimal characters, called a loose object.
- inside a packfile for greater efficiency.

TODO confirm: objects are stored with zlib DEFLATE algorithm,
but only the payload is stored, so they are not in the `gz` format as specified by
<http://www.gzip.org/zlib/rfc-gzip.html#file-format> which contains many extra metadata,
and therefore cannot be decompressed with `gunzip`.
<http://stackoverflow.com/questions/1532405/how-to-view-git-objects-and-index-without-using-git>

What would happen if collision happened: the old object is kept
<http://stackoverflow.com/questions/9392365/how-would-git-handle-a-sha-1-collision-on-a-blob>

Malicious collisions wouldn't have much of an effect since you have to commit them first.

Every object has three properties:

- type
- length of the content
- content

TODO what is the size in bytes for the type and length?

Git uses 4 types of object on the same content addressable filesystem.

- commit
- tree
- blob
- tag

In practice, only commit SHA-1 are used in everyday Git usage,
while the others objects are referred to by more intuitive aliases.

### Commit object

Represents a version. Contains:

- the SHA-1 of the parents if any.
- one tree object, the root of the commit
- author information and creation timestamp
- committer information and commit timestamp
- the commit message

Note how the timestamp and parent are part of the content and thus influences the SHA-1:
therefore, you cannot change the timestamp of a past commit without changing the timestamp
of all commits that follow.

In `cat-file`:

    git cat-file -p HEAD

    tree e4c4fa4f49a16c8e4c5edfc7274e5cd2a7cd58d2
    parent add0caccfd13a063d5adff972b3e5a673cee1e40
    author Ciro Santilli <ciro.santilli@gmail.com> 1409654129 +0200
    committer Ciro Santilli <ciro.santilli@gmail.com> 1409654129 +0200

    assert_select, ERB tests.

If there was no parent it would print just:

    tree 496d6428b9cf92981dc9495211e6e1120fb6f2ba
    author Ciro Santilli <ciro.santilli@gmail.com> 1409841443 +0200
    committer Ciro Santilli <ciro.santilli@gmail.com> 1409841443 +0200

### Low level commit creations example

Create a Git repository without a working tree:

    git init --bare

    empty_blob="$(printf '' | git hash-object --stdin -w)"

    sub_tree="$(printf "\
    100644 blob $empty_blob\ta
    " | git mktree)"

    root_tree="$(printf "\
    040000 tree $sub_tree\td
    100644 blob $empty_blob\ta
    100644 blob $empty_blob\tb
    " | git mktree)"

    commit="$(git commit-tree -m 0 "$root_tree")"

    git branch master "$commit"

The repository will contain a single commit with message `0` pointing to the tree:

    d/a
    a
    b

where all files are empty.

This method allows you to overcome some filesystem "limitations":

-   infinite name width:

        100644 blob $empty_blob\t$(printf '%1024s' ' ' | tr ' ' 'a')

    Limited to 255 on ext filesystems, shows on GitHub, but checkout fails.

-   `.` and `..`. Cannot push to GitHub.

-   path containing a slash `/`. Blocked by `mktree` directly.

-   path containing a NUL. `mktree` treats filename as ending at the NUL.

You can also attempt to overcome Git filename restrictions:

-   empty tree:

        sub_tree="$(printf '' | git mktree)"

    Will be present, and shown on GitHub, <https://github.com/cirosantilli/test-empty-subdir> but generated on clone.

    Commits may point to it the empty tree when the repository is empty,

    This can be achieved with the porcelain `git commit -allow-empty` on an empty repository.

-   a or directory named `.git`:

        100644 blob $empty_blob\t.git
        040000 tree $sub_tree\td

    Prevents push to GitHub.

Manually corrupt the repository by making trees and commits point to non-existent objects: `git mktree --missing`.
`git push` does not work on those.

#### commit-tree

Low level commit creation from a given tree object.

Can take custom inputs from the following environment variables:

    GIT_AUTHOR_NAME
    GIT_AUTHOR_EMAIL
    GIT_AUTHOR_DATE
    GIT_COMMITTER_NAME
    GIT_COMMITTER_EMAIL
    GIT_COMMITTER_DATE
    EMAIL

Once you have created a tree object with this command,
you can update a branch reference to point to it with `git update-ref`.

### Tree object

Represents a directory and subdirectories.

Contains a list of blobs and trees and their metadata.

To get the SHA-1 of a tree you can:

- look at the root of a commit `cat-file`
- `ls-tree`

Let's cat it:

    git cat-file -p e4c4fa4f49a16c8e4c5edfc7274e5cd2a7cd58d2

Sample output:

    100644 blob 1944fd61e7c53bcc19e6f3eb94cc800508944a25	.gitignore
    100644 blob a0061019ab73e09ead85b90a8041e71108148bcb	.vimrc
    100644 blob a3db99ea9cda27e10e5a8091618491946bf4bb10	README.md
    040000 tree b110e36127f6578433bd68633c68dc8aa96c4f5e	app

TODO: what is the exact format of tree objects? It is not this plain text representation,
since sing it with `git hash-object` fails, and the SHA of the empty tree is different from that
of the empty blob.

As we can see, it contains other trees and blobs, just like the output of `ls-tree`.

The index does not stores trees but rather has a specialized file format,
probably for greater efficiency. There are however commands like `write-tree` and `read-tree`
that transform between tree objects and the index.

#### ls-tree

List tree for current directory at given commit:

    git ls-tree HEAD

List tracked files recursively starting from the root:

    git ls-tree --full-tree -r HEAD

Sample output:

    100644 blob 867f193a98f573e65a69b336c8205ea392c84c0e    public/404.html
    100644 blob b6c37ac53866f33aabea2b79ebc365053dbe8e77    public/422.html

Meaning of fields:

1.  Git file permission notation: <http://stackoverflow.com/questions/737673/how-to-read-the-mode-field-of-git-ls-trees-output>

2.  type: tree, blob

3.  SHA of each object: <http://stackoverflow.com/questions/10150541/how-to-suppress-the-output-of-return-value-in-irb-rails-console>
    You have to know that there are other objects besides commits, in particular blobs and trees,
    and they are indexed by SHA-1.

TODO: what does `--full-tree` do exactly?

TODO: how to `ls-tree` a given path?

#### mktree

Create a tree object from `ls-tree` output.

### Blob object

Represents a file. Contain the file content, no metadata (filename and permissions).

Blobs are represented as the entire file, not as diffs.

This way makes things faster since you don't have to resolve tons of diffs to get a version of a file,
and is not too memory inefficient since identical files will have the same SHA and only get stored once.

Git can also pack similar files into single objects for greater efficiency
this functionality is implemented using a structure called a packfile.

### Tag object

Points to another object to give it a nicer name. Contents;

- `object`: the SHA-1 of the object it points to
- `type`: the type of the object it points to
- `tag`: the tag name
- the tag message, possibly containing a GPG key

Example:

    git cat-file tag v7.2.1

Output:

    object ff1633f418c29bd613d571107df43396e27b522e
    type commit
    tag v7.2.1
    tagger Jacob Vosmaer <contact@jacobvosmaer.nl> 1409231481 +0200

    Version 7.2.1

Although it does not have many side effects for git,
you can tag whatever object you want. E.g., if you have the SHA of a blob, you can do:

    git tag blobtag <SHA>

And then:

    git show blobtag

will `cat` the contents of that file.

For git to be able to find tags from their names, it stores them under `.git/refs`.

There are however some side effects even for tags on non-commits:

- `^{}ref` recursively resolves tags until a commit is found

### cat-file

Get information about objects.

The output for each object will be documented with it's description.

Pretty print a commit:

    git cat-file -p HEAD

    tree e4c4fa4f49a16c8e4c5edfc7274e5cd2a7cd58d2
    parent add0caccfd13a063d5adff972b3e5a673cee1e40
    author Ciro Santilli <ciro.santilli@gmail.com> 1409654129 +0200
    committer Ciro Santilli <ciro.santilli@gmail.com> 1409654129 +0200

    assert_select, ERB tests.

`1409654129` are the seconds since epoch.

Also works for all other object types:

    git cat-file -p HEAD:./
    git cat-file -p HEAD:./.gitignore

Get object type and size:

    git cat-file -t HEAD
    git cat-file -s HEAD

Outputs:

    commit
    252

We can also confirm the size with:

    git cat-file -p | wc -c

### hash-object

Compute hash of a given file:

    echo a > a
    git hash-object a

Output:

    78981922613b2afb6025042ff6bd878ac1994e85

From stdin:

    echo 'a' | git hash-object --stdin

Create a blob object from a file:

    echo a > a
    git hash-object -w a

Create objects of other types with `-t`.
You cannot however create other objects directly from human readable formats,
e.g., `ls-tree` output can only be used to create trees with `mktree`.

### Loose object

An object that is not stored inside a packfile.

### Packfiles

<https://github.com/gitster/git/blob/master/Documentation/technical/pack-format.txt>

<http://git-scm.com/book/en/Git-Internals-Packfiles>

Stores multiple files under:

- `.git/objects/packs/patck-<SHA>.pack`
- `.git/objects/packs/patck-<SHA>.idx`

pairs.

### repack

The `git repack` command tells Git to try and package more objects where it can.

### unpack-objects

The `git repack` command tells Git to unpack objects from pack files.

## description file

Created by default at `.git/description`.

Only used by the GitWeb program, never internally, and not used by GitHub either.

<http://stackoverflow.com/questions/6866838/what-should-be-in-the-git-description-file>

# git options

Options that apply directly to `git` and therefore can be used with any subcommand.

Set path to a custom working tree and bare repository (like a `.git` directory in a working tree):

    git --work-tree='repo.git' --work-tree='repo' status

# contrib

Under the git source tree there is a directory called contrib
which includes features that are not yet part of the main distribution,
but are being considered.

Any information contained on this section is more volatile than the others.

Since these commands are so recent,
they may not be installed with the Git version that comes from your package manager.

Git subcommands must be available as:

    /usr/lib/git-core/git-SUBCOMMAND_NAME_NO_EXTENSION

for example as:

    /usr/lib/git-core/git-tag

Other commands may simply need to be in the PATH.

## subtree

Split a directory of a repository into another repository.

*Maintains* history in the new repository.

Great tutorial: <http://stackoverflow.com/a/17864475/895245>

Install:

    mkdir -p ~/bin && cd ~/bin && wget -O git-subtree https://raw.githubusercontent.com/git/git/master/contrib/subtree/git-subtree.sh && chmod +x git-subtree
    sudo ln -s git-subtree /usr/lib/git-core/git-subtree

Create a new branch containing only commits that affected the given directory,
and put the subdirectory at the root of the repo on that branch:

    git subtree split -P <subdirectory> -b <new-branch>

History of the large repository is untouched.

The `<subdirectory>` directory may still exist because of gitignored files it contains.

To extract it just:

    cd ..
    git clone <big-repo> -b <new-branch> <new-repo>
    cd <new-repo>
    git branch -m <new-branch> master

And don't forget to clean up the big directory:

    git branch -D <new-branch>
    git rm -r <subdirectory>
    rm -rf <subdirectory>

You also probably want to reuse part of the `.gitignore`
and other top-level git config files from the larger directory.

## diff-highlight

`git diff --word-diff=color` is probably better than this when you are sure that you want
a word diff for a file: the advantage of this solution is that it works well for both
prose and programming languages.

Highlight which parts of a line were modified, similar to by most web interfaces today.

![diff-highlight](diff-highlight.png)

It does a regular line-wise diff, but highlights the words changed between two lines.

It is simply a Perl script, and you can install it with:

    cd ~/bin && curl -O https://raw.github.com/git/git/master/contrib/diff-highlight/diff-highlight && chmod +x diff-highlight
    git config --global pager.log 'diff-highlight | less'
    git config --global pager.show 'diff-highlight | less'
    git config --global pager.diff 'diff-highlight | less'

Now when using `git diff --color`, this will work automatically.

# Third party tools

## tig

Powerful curses gitk written in C: <https://github.com/jonas/tig>.

Install Ubuntu 12.04:

    sudo aptitude install tig

Manpages:

    man tig
    man tigrc

And help inside tig:

    h

### Views

Tig has many views:

- log (initial view)
- branches
- tree (directory)
- blob (file)

The bindings you can use depend on which view you are currently on.

For instance, it only makes sense to view a blame `B` if you are either on a tree or blob view.

There is currently no `remotes` view: <https://github.com/jonas/tig/issues/199>

### Generic

General mappings:

- `Space`: one screen down
- `b`: one screen up
- `H`: see a list of branches.

### Refs tig

These bindings are available on views that shows revisions such as the log view or the branches view.

- `C`: checkout to the commit.
- `<enter>`: open a list of the commits inline.

### Blob

- `e`: open file in editor. Default: `vim`.
- `B`: blame view of file
    - `Enter`: open `log -p` of current line's commit inline.

## fugitive

Vim plug-in with large overlap with tig functionality: <https://github.com/tpope/vim-fugitive>

## fame

Get stats on file / line and commit percents per author.

Home: <https://github.com/oleander/git-fame-rb>

Install:

    gem install git_fame

Usage:

    git fame

Sample output:

    +------------------------+--------+---------+-------+--------------------+
    | name                   | loc    | commits | files | distribution       |
    +------------------------+--------+---------+-------+--------------------+
    | Johan Sørensen         | 22,272 | 1,814   | 414   | 35.3 / 41.9 / 20.2 |
    | Marius Mathiesen       | 10,387 | 502     | 229   | 16.5 / 11.6 / 11.2 |
    | Jesper Josefsson       | 9,689  | 519     | 191   | 15.3 / 12.0 / 9.3  |
    | Ole Martin Kristiansen | 6,632  | 24      | 60    | 10.5 / 0.6 / 2.9   |
    | Linus Oleander         | 5,769  | 705     | 277   | 9.1 / 16.3 / 13.5  |
    | Fabio Akita            | 2,122  | 24      | 60    | 3.4 / 0.6 / 2.9    |
    | August Lilleaas        | 1,572  | 123     | 63    | 2.5 / 2.8 / 3.1    |
    | David A. Cuadrado      | 731    | 111     | 35    | 1.2 / 2.6 / 1.7    |
    | Jonas Ängeslevä        | 705    | 148     | 51    | 1.1 / 3.4 / 2.5    |
    | Diego Algorta          | 650    | 6       | 5     | 1.0 / 0.1 / 0.2    |
    | Arash Rouhani          | 629    | 95      | 31    | 1.0 / 2.2 / 1.5    |
    | Sofia Larsson          | 595    | 70      | 77    | 0.9 / 1.6 / 3.8    |
    | Tor Arne Vestbø        | 527    | 51      | 97    | 0.8 / 1.2 / 4.7    |
    | spontus                | 339    | 18      | 42    | 0.5 / 0.4 / 2.0    |
    | Pontus                 | 225    | 49      | 34    | 0.4 / 1.1 / 1.7    |
    +------------------------+--------+---------+-------+--------------------+

## browse remote

Open current remote on browser.

Smart: considers current branch / revision. More intelligent than `hub browse`.

Home: <https://github.com/motemen/git-browse-remote>

Install:

    gem install git-browse-remote

Usage:

    git browse-remote

## git-cache-meta

Save and apply all UNIX permissions. Git only keeps `x` and symlink bits.

Save all permissions to file `.git_cache_meta`:

    git-cache-meta --store

Apply permissions after clone:

    git-cache-meta --apply

Not sure who wrote it originally, but there are some Gists containing the script:

    cd ~/bin
    wget https://gist.githubusercontent.com/andris9/1978266/raw/git-cache-meta.sh
    chmod +x git-cache-meta.sh

One downside is that this script always stores file owner,
but when publishing a file to other users, we are only interested in storing read write permissions.

The situation is complicated because sometimes we do want the owner to be kept:
e.g. when a file must be owned by `root`.

## libgit2

<https://github.com/libgit2/libgit2>

Reimplementation of the Git core methods. Differences from Git:

-   meant to be used from a C directly as a linked library:
    does not have a native command line interface

-   is GPLv2 with linking exception: proprietary projects can link to it unmodified.

    This is the perfect move for GitHub,
    since it forces other companies to merge back if they want to modify it,
    this improving the software.

    Git is pure GPLv2.

It uses the exact same `.git` repository format as Git.

Has bindings in many higher level languages like Rugged for Ruby.
This is one of the greatest things about libgit2:
since it implements a C interface, other languages will just have wrappers around it,
making all those other libraries more uniform, thus easier to learn, and less buggy.

Its development was started and is strongly backed by GitHub which uses it internally.
Its license is more open than Git's, as it can be used by proprietary software if not modified.

libgit2 has reused a small portion of the code in the original Git source
from authors that allowed the new license:
<http://stackoverflow.com/questions/17151597/which-code-is-shared-between-the-original-git-and-libgit2>
It is worth noting that many major authors have allowed such usage, including Linus and Hamano.

It was designed to replace the Ruby Grit library which initially powered GitHub.
Grit only parsed Git output from stdin, so it is much slower than the new native C implementation
of libgit2 which works directly with the repository.

# GitHub specific

The git URL is then `git@github.com:userid/reponame.git`

## Pull request refs

GitHub stores refs to pull requests on the original repository under `refs/pull/<number>/head`.

Therefore, if you want to get a pull request locally to try it out on a local branch you can do:

    git fetch origin pull/<pr-number>/head
    git checkout -b <local-branch-name> FETCH_HEAD

## GitHub API v3 via cURL

GitHub has an HTTP REST API, which allows you to:

-   programmatically access and modify GitHub data

-   overcome certain web interface limitations.

    For example, on the web interface, you can only see up to 30 results
    for the starred repos of other people.

    With the API, you can get all of them at once and grep away by playing with `per_page`.

`curl` is a convenient way to use the API manually.

Vars:

    USER=user
    REPO=repo
    PASS=

GET is the default request type:

    curl https://api.github.com/users/$USER/starred?per_page=9999909 | grep -B1 "description" | less

Make a POST request with `curl`:

    echo '{
      "text": "Hello world github/linguist#1 **cool**, and #1!",
      "mode": "gfm",
      "context": "github/gollum"
    }' | curl --data @- https://api.github.com/markdown

### Authentication

Many methods that take a user can use the authenticated user instead if present.

Basic with user password pair:

    curl -u "cirosantilli-puppet" https://api.github.com/user/orgs

Or:

    curl -u "cirosantilli-puppet:password" https://api.github.com/user/orgs

### OAuth

OAuth: generate a large random number called the *access token*.
Which you can only get once.

There are two ways to get the token:

-   personal tokens, generated by a logged in user from: <https://github.com/settings/tokens/new>

    Useful if you need to generate only a few tokens for personal use.

-   application obtained token.

    A way for applications to interact with GitHub and obtain a token.

    User is first redirected to GitHub, inputs his password only there,
    and the token is sent back to the application.

    Useful if you are building an application that must interact with GitHub,
    and don't want to store the user's password.

    Each user gets a single token per application in case multiple token requests are made.

Tokens are safer than storing the password directly because:

- it is possible to restrict what can be done with each token,
    thus increasing confidence users have on your application.

- users can revoke tokens at any time, without changing their passwords.

Once you get the token, make an authenticated request with:

    curl https://api.github.com/user?access_token=TOKEN

### Rate limiting

- authenticated: 60 requests per hour
- unauthenticated requests: 5000 requests per hour

<http://developer.github.com/v3/#rate-limiting>

### per_page

Get given number of results. Default is 30. Allows you to beat web API limitations. List all starred repos of a user:

    curl https://api.github.com/users/$USER/starred?per_page=9999909 | grep -B1 "description" | less

### Get repo info

Lots of info:

    curl -i https://api.github.com/users/$USER/repos

### Create repo

    USER=
    REPO=
    curl -u "$USER" https://api.github.com/user/repos -d '{"name":"'$REPO'"}'

Repo name is the very minimal you must set, but you could also set other params such as:

    curl -u "$USER" https://api.github.com/user/repos -d '{
       "name": "'"$REPO"'",
       "description": "This is your first repo",
       "homepage": "https://github.com",
       "private": false,
       "has_issues": true,
       "has_wiki": true,
       "has_downloads": true
    }'

Its just JSON (remember, last item cannot end in a comma).

### Delete repo

    curl -u "$USER" -X DELETE https://api.github.com/repos/$USER/$REPO

Careful, it works!

## hub

Powerful CLI interface: <https://github.com/github/hub>

    gem install hub

Open URL of current branch / commit in browser:

    hub browse

Create repository with same name as current dir:

    hub create

Give a name and a description:

    hub create name -d 'Description'

# Test repos

Use those to test stuff.

They can be generated with the `generate-test-repos.sh` script

They are described here.

## 0

2 files uncommitted

    ls
        #a b
    cat a
        #a1
    cat b
        #b1
    git status
        #untracked: a b

## 0du

Same as `0`, but with an untracked subdir `d`:

    ls
        #a b d
    ls d
        #a b
    cat d/a
        #da
    cat d/b
        #db

    git status
        #untracked: a b d/

## 1

Same as `0`, but committed.

    ls
        #a b
    cat a
        #a1
    cat b
        #b1
    git status
        #no changes

    (1)
     |
     master

## 1d

Same as `0d`, but with all tracked.

## 1u

Same as `1`, but one untracked file `c` added.

    ls
        #a b c
    cat a
        #a1
    cat b
        #b1
    cat c
        #c1

    git status
        #untracked: c

    (1)
     |
     master
     HEAD

## 1ub

Same as `1ub` + one branch.

Current branch is `master`.

    ls
        #a b c
    cat a
        #a1
    cat b
        #b1
    cat c
        #c1

    git status
        #untracked: c

    (1)
     |
     master *
     b

## 2

2 commits and 2 files committed.

    ls
        #a b
    cat a
        #a1
        #a2
    cat b
        #b1
        #b2

    git status
        #no changes

    (1)-----(2)
             |
             HEAD
             master

## 2u

Same as `2` + 1 file uncommitted.

    ls
        #a b c
    cat a
        #a1
        #a2
    cat b
        #b1
        #b2
    cat c
        #c1
        #c2

    git status
        #untracked: c

    (1)-----(2)
             |
             HEAD
             master

## 2b

Two branches unmerged, no uncommitted files.

Tree:


    (1)-----(2)
     |       |
     |       master *
     |
     +------(b2)
             |
             b

Files:

    git checkout master

    ls
        #a b c
    cat a
        #a1
    cat b
        #b1
    cat c
        #c1

    git checkout b

    ls
        #a b c
    cat a
        #a1
        #a2
    cat b
        #
    cat d
        #d1

## 3

3 commits 2 files.

Looks like:

    ls
        #a b
    cat a
        #a1
        #a2
        #a3
    cat b
        #b1
        #b2
        #b3

    git status
        #no changes

    (1)-----(2)-----(3)
                     |
                     master *

## 0bare

Bare repo.

## multi

Contains multiple repos for inter repo tests.

It looks just like the GitHub fork model.

The repos are:

    ls
        #a ao b bo

Where:

-   `a`: original local repository

-   `ao`: bare uploaded repository of `a`.

    `origin` of `a` and `bo`, `upstream` of `b`.

-   `bo`: remote fork of `ao`.

    Origin of `b`

-   `b`: local clone of fork.

Also:

-   `a` has a branch `master` and a branch `b`

## multiu

Like `multi`, but both master branches have committed unmerged modifications.

[bitbucket]: https://www.bitbucket.org/
[github]:    https://github.com/
[gitorious]: http://gitorious.org/
[vcs]:       http://en.wikipedia.org/wiki/Revision_control
