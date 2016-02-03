---
title: Build
social_media: true
permalink: git-tutorial/build/
---

How to build git from source.

Good default command (tested Ubuntu 15.10):

    sudo apt-get build-dep git
    sudo apt-get install autoconf docbook2x libssl-dev
    make configure
    ./configure
    time make -j$(nproc) all man
    time make -j$(nproc) install install-man
    # Add ~/bin to PATH.

Build everything, including docs:

    time make -j$(nproc) all doc html info man

The ones that matter are:

    time make -j$(nproc) all man

Install to default prefix:

    time make -j$(nproc) install install-man

By default:

- `git` goes to `~/bin`, which is great and does not require sudo
- manpages go to `~/share/man` which is 2.7.4 searches for by default on Ubuntu 15.10

Install to given prefix:

    time make -j$(nproc) prefix="$(pwd)/../install" install

Install everything:

	time make -j$(nproc) prefix="$(pwd)/../install" install install-doc install-info install-html install-man
