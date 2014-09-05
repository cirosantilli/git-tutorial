---
title: SVN for Git users.
---

Create new SVN controlled folder:

    svnadmin create project

Clone:

    svn checkout https://subversion.assembla.com/svn/cirosantillitest/

Clone version number 3:

    svn checkout -r 3 file:///home/user/svn project

Every time you commit increases this number.

Take a non SVN file directory and convert it to SVN controlled one:

    svn import nonsvn svn

Commit. If your SSH is added, this pushes to the original repository. In SVN everything happens over the network.

    svn commit -m 'commit message'

History of commits:

    svn log

What is committed, changed and tracked:

    svn status

Must use to make dirs, `-m` to commit with message:

    svn mkdir foo -m 'commit message'

Must use to remove dirs, `-m` to commit with message:

    svn rmdir foo -m 'commit message'

Add to version control:

    svn add

Get single file from repo, modify it, and up again

    svn co https://subversion.assembla.com/svn/cirosantillitest/ . --depth empty
    svn checkout readme.textile
    vim readme.textile
    svn ci -m 'modified readme.textile'
