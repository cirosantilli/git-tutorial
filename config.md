---
title: config
social_media: true
---

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

List the currently used value of all non-default configs:

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

Set boolean:

    git config X true
    git config X false

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
-   `core.excludesfile`: path of a global `.gititnore` file for all projects.
-   `commit.template`: commit message template file path

### autocrlf

`core.autocrlf` deals with Windows CRLF line terminator issues.

<http://stackoverflow.com/a/1250133/895245>

Possible values:

- `false`: (default) don't touch your code. This is what you should need if you have a good editor and workflow...
- `true`: on checkout, convert LF to CRLF. On checkout, convert LF to CRLF.
- `input`: CRLF to LF on commit. Nothing on checkout.

Conversions are only done if the entire file has a single line termination style: if there is at least one single different line ending, nothing ever gets done by Git.

Conversions don't touch the working directory: only the repository contents.

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

    git config --global alias.sh '!exec '

Allowing you to do any command at top-level:

    git exec sh

## UTF8 filenames

<http://stackoverflow.com/questions/5854967/git-msysgit-accents-utf-8-the-definitive-answers>

### quotepath

If `true`, file paths that contain characters non printable bytes are printed as quoted C strings literals in commands, in particular UTF-8 characters are encoded.

If `false` and the encoding is compatible with your terminal, you will see nice characters.

So should be `false` for UTF-8 usage.

