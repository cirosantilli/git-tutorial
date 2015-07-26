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

## Show only the names of changed files

<http://stackoverflow.com/questions/1552340/show-all-changed-files-between-two-git-commits>:

    git diff-tree --no-commit-id --name-only -r HEAD

Sample output:

    file1.md
    file2.md

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
