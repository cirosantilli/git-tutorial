---
title: Internals
---

Learn them as early as possible: they unify many topics.

Git offers lots of commands to manipulate low level internals stuff.

## .git directory

Holds all the Git information.

- `logs`: information for `reflog`.

## Objects

Good source: <http://git-scm.com/book/en/Git-Internals-Git-Objects>

### Object location

Git implements a generic content addressable filesystem on top of your filesystem: given the content of an object you can find the address, which is it's SHA-1.

The main advantage of this method is that given a content like a commit you can easily determine where it will be stored in a way that will not conflict with other objects, which are potentially create by other users.

Another advantage is that identical objects like files are only stored once even if present in multiple revisions. And this is a very common case, since in large repositories only few files change with each new version.

The content addressable filesystem is implemented under `.git/objects` as either of:

-   loose objects
-   packfiles for greater storage efficiency

What would happen if collision happened: the old object is kept <http://stackoverflow.com/questions/9392365/how-would-git-handle-a-sha-1-collision-on-a-blob> Malicious collisions wouldn't have much of an effect since you have to commit them first.

#### Alternatives

It is also possible to store objects on a custom directory with the `alternatives` system: <http://dustin.sallings.org/2008/12/30/git-alternates.html>

This allows you to reuse all objects across multiple repositories. Used by GitHub: <http://githubengineering.com/counting-objects/>

### Object types

Git stores 4 types of object on the same content addressable filesystem:

- commit
- tree
- blob
- tag

In practice, only commit SHA-1 are used in everyday Git usage, while the others objects are referred to by more intuitive aliases.

### Commit object

Represents a version. Contains:

- the SHA-1 of the parents if any.
- one tree object, the root of the commit
- author information and creation timestamp
- committer information and commit timestamp
- the commit message

Note how the timestamp and parent are part of the content and thus influences the SHA-1: therefore, you cannot change the timestamp of a past commit without changing the timestamp of all commits that follow.

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

### Manual commit creations example

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
    " | git mktree)"

    commit="$(git commit-tree -m 0 "$root_tree")"
    git branch master "$commit"

    # Modify the master branch

    root_tree="$((
    git ls-tree HEAD:./
    printf "\
    100644 blob $empty_blob\tb
    ") | git mktree)"

    commit="$(git commit-tree -m 1 -p "$(git rev-parse HEAD)" "$root_tree")"
    # Bare
    #git update-ref master "$commit"
    # Non bare
    git reset --hard "$commit"

The repository will contain a two commits with message `0` and `1` pointing to the trees:

    d/a
    a

and:

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

#### Empty tree

    sub_tree="$(printf '' | git mktree)"

Will be present, and shown on GitHub, <https://github.com/cirosantilli/test-empty-subdir> but generated on clone.

Commits may point to it the empty tree when the repository is empty,

This can be achieved with the porcelain `git commit --allow-empty` on an empty repository.

---

-   a or directory named `.git`:

        100644 blob $empty_blob\t.git
        040000 tree $sub_tree\td

    Prevents push to GitHub.

Manually corrupt the repository by making trees and commits point to non-existent objects: `git mktree --missing`. `git push` does not work on those.

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

Once you have created a tree object with this command, you can update a branch reference to point to it with `git update-ref`.

##### Squash branch to a single commit

<http://stackoverflow.com/questions/1657017/squash-all-git-commits-into-a-single-commit>

Squash repository to a single commit:

    git reset $(git commit-tree HEAD^{tree} -m "commit message")

where:

- `HEAD^{tree}` means the first `tree` type object found from commit `HEAD`.
- `commit-tree` takes a tree object, and makes a commit out of it

### Tree object

Internal format:

- <http://stackoverflow.com/questions/12256214/how-does-git-store-tree-objects>
- <http://stackoverflow.com/questions/14790681/what-is-the-internal-format-of-a-git-tree-object>

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

TODO: what is the exact format of tree objects? It is not this plain text representation, since sing it with `git hash-object` fails, and the SHA of the empty tree is different from that of the empty blob.

As we can see, it contains other trees and blobs, just like the output of `ls-tree`.

The index does not stores trees but rather has a specialized file format, probably for greater efficiency. There are however commands like `write-tree` and `read-tree` that transform between tree objects and the index.

#### ls-tree

List tree for current directory at given commit:

    git ls-tree HEAD

List tracked files recursively starting from the root:

    git ls-tree --full-tree -r HEAD

Sample output:

    100644 blob 867f193a98f573e65a69b336c8205ea392c84c0e    public/404.html
    100644 blob b6c37ac53866f33aabea2b79ebc365053dbe8e77    public/422.html

Meaning of fields:

1. Git file permission notation: <http://stackoverflow.com/questions/737673/how-to-read-the-mode-field-of-git-ls-trees-output>
2. type: tree, blob
3. SHA of each object: <http://stackoverflow.com/questions/10150541/how-to-suppress-the-output-of-return-value-in-irb-rails-console> You have to know that there are other objects besides commits, in particular blobs and trees, and they are indexed by SHA-1.

TODO: what does `--full-tree` do exactly?

TODO: how to `ls-tree` a given path?

#### mktree

Create a tree object from `ls-tree` output.

### Blob object

Represents a file. Contain the file content, no metadata (filename and permissions).

Blobs are represented as the entire file, not as diffs.

This way makes things faster since you don't have to resolve tons of diffs to get a version of a file, and is not too memory inefficient since identical files will have the same SHA and only get stored once.

Git can also pack similar files into single objects for greater efficiency this functionality is implemented using a structure called a packfile.

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

Although it does not have many side effects for git, you can tag whatever object you want. E.g., if you have the SHA of a blob, you can do:

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

Create objects of other types with `-t`. You cannot however create other objects directly from human readable formats, e.g., `ls-tree` output can only be used to create trees with `mktree`.

It does not seem possible to calculate bare SHAs from the Git command line: the SHA input also includes the type and length.

Other object types:

    printf '' | git hash-object --stdin -t tree

#### Well known SHA-1s

##### 0000000000000000000000000000000000000000

All zeros: `'0' * 40`. Indicates a blank object, used on the output of many commands as a magic placeholder when something is deleted or created.

##### da39a3ee5e6b4b0d3255bfef95601890afd80709

    printf '' | sha1sum

Output:

    da39a3ee5e6b4b0d3255bfef95601890afd80709

This should never appear in Git (unless you've found the collision!) since every object is prefixed by the type and length.

##### e69de29bb2d1d6434b8b29ae775ad8c2e48c5391

Empty blob:

    printf '' | git hash-object --stdin
    printf 'blob 0\0' | sha1sum

Output:

    e69de29bb2d1d6434b8b29ae775ad8c2e48c5391

##### 4b825dc642cb6eb9a060e54bf8d69288fbee4904

Empty tree: <http://stackoverflow.com/questions/9765453/gits-semi-secret-empty-tree>

    printf '' | git hash-object --stdin -t tree
    printf 'tree 0\0' | sha1sum

Output:

    4b825dc642cb6eb9a060e54bf8d69288fbee4904

Different from the SHA of the empty blob because the type is included in the input.

### Loose object

An object that is not stored inside a packfile but rather under:

    .git/objects/<2 first bytes of SHA>/<38 last bytes of SHA>

e.g., the empty blob is always at:

    .git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391

The object format is:

- type string
- space
- human readable length of the content
- NUL
- content

For blob:

    s='abc'
    printf "$s" | git hash-object --stdin
    printf "blob $(printf "$s" | wc -c)\0$s" | sha1sum

Objects are stored with zlib DEFLATE algorithm, but only the payload is stored, so they are not in the `.gz` format as specified by <http://www.gzip.org/zlib/rfc-gzip.html#file-format> which contains many extra metadata, and therefore cannot be decompressed with `gunzip`:

- <http://stackoverflow.com/questions/1532405/how-to-view-git-objects-and-index-without-using-git>
- <http://stackoverflow.com/questions/3178566/deflate-command-line-tool>

Enough talk, let's open some loose objects manually. Starting from the `min-sane` test repository:

    python -c 'import zlib,sys;sys.stdout.write(zlib.decompress(sys.stdin.read()))' \
      < .git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391 | hd

Output:

    00000000  62 6c 6f 62 20 30 00    |blob 0.|
    00000007

