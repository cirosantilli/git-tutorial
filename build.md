---
title: Build
social_media: true
---

Information about building git from source.

Build:

    sudo apt-get build-dep git
    sudo apt-get install docbook2x
    make -j$(nproc)

Build everything, including docs:

    make -j$(nproc) all doc html info man # html

Install to given prefix:

    make -j$(nproc) prefix="$(pwd)/../install" install

Install everything:

	make -j$(nproc) prefix="$(pwd)/../install" install install-doc install-info install-html install-man
