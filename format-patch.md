# format-patch

Generate a patch to send by email.

Generate a patch from last commit:

    git format-patch HEAD~

## Signed-off by

Extra text added to commit messages or only to patches.

Required by certain projects, notably the Linux kernel, because of legal reasons: <http://stackoverflow.com/questions/1962094/what-is-the-sign-off-feature-in-git-for>

Has no relation to GPG signatures.

Add signed-off by line to the commit message:

    git commit -ms 'Message.'

This would generate a commit message like:

    Message.

    Signed-off-by: Super Developer <super.dev@gmail.com>

Normally you don't need to pollute the commit message: just add it to the patch sent by email:

    git format-patch -s
