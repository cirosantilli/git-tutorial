---
title: SVN
social_media: true
---

## Create

Init:

    svnadmin create $path

The path must not exist.

Clone:

    svn checkout https://subversion.assembla.com/svn/cirosantillitest/

Clone version number 3:

    svn checkout -r 3 file:///home/user/svn project

Every time you commit increases this number.

Take a non-SVN file directory, convert it to SVN controlled one and push with the given commit message:

    svn import "$local_path" "$remote_url" -m "$commit_message"

## checkout

    svn switch ^/branches/abranch
    svn switch ^/tags/1.2.3

## tag

## branch

List <http://stackoverflow.com/users/1305501/nosid> No kidding:

    svn ls -v ^/
    svn ls -v ^/tags
    svn ls -v ^/branches

---

Add:

    svn add $file

Commit. If your SSH is added, this pushes to the original repository. In SVN everything happens over the network.

    svn commit -m 'commit message'

Log:

    svn log

Status:

    svn status

Must use to make directories, `-m` to commit with message:

    svn mkdir foo -m 'commit message'

Must use to remove directories, `-m` to commit with message:

    svn rmdir foo -m 'commit message'

Get single file from repo, modify it, and up again

    svn co https://subversion.assembla.com/svn/cirosantillitest/ . --depth empty
    svn checkout readme.textile
    vim readme.textile
    svn ci -m 'modified readme.textile'
