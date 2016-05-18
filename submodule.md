---
title: submodule
social_media: true
---

A submodule is a git repository included inside another at a version fixed by the parent.

Submodules are used to factor out directories which are used in multiple repositories.

This approach is useful when there is no way to:

- share a file between programs (like `PATH` does for executable)
- maintain different versions of a program (like `virtualenv` does for Python)

for a given technology.

If a better system does exist for you repository however, e.g. Python / Ruby modules + virtualenv / RVM, use that method instead.

A submodule is a completely separate repo: the super repository only keeps note of its path, URL and current commit.

## Create a submodule

Create on directory `.latex`:

    git submodule add https://github.com/cirosantilli/test.git
    git add .gitmodules
    git commit -m 'Add submodule'

Modifies / creates `.gitmodules`, which you should then `git commit`.

If the directory exists and contains the required git repository already, nothing is done.

Else, the repository is cloned.

Add to another directory:

    git submodule add https://github.com/USERNAME/latex.git another_name

## Submodule symlink combo

If your technology requires files to be in the current directory, you can use symlinks into the submodule to achieve that effect.

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

It seems that making clone recursive by default is neither possible nor a good idea: <http://stackoverflow.com/questions/4251940/retrospectively-add-recursive-to-a-git-repo>

## Update content of a submodule

    cd share
    git pull

Now from the main repository;

    cd ..
    git status
        #modified:   shared (new commits)

For your repo to incorporate this update, you have to add the submodule path (`share/`) and commit, or simply do a `commit -a` next time.

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

## Remove submodule

## deinit

As of git 1.8.3:

    git submodule deinit path

Files are kept and the `.gitmodule` file is not edited, but internally the module is removed and you can get rid of those.

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
