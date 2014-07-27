#!/usr/bin/env bash

set -eu

outdir="_out"
copy_script="copy.sh"

F="$(basename "$0")"
usage() {
  echo "generate and remove git test repos

# Examples

Create tests:

  $F

They are put inside a dir named: $outdir

Delete tests:

  $F clean

The output dir is completelly removed.

Show this help:

  $F help
" 1>&2
}

if [ $# -gt 0 ]; then
  if [ $1 = clean ]; then
    rm -rf $outdir
    exit 0
  elif [ $1 = help ]; then
    usage
  else
    usage
    exit 1
  fi
else
  rm -rf $outdir
  mkdir "$outdir"
  cp "$copy_script" "$outdir"
  cd "$outdir"
  chmod +x "$copy_script"

  #0

  mkdir 0
  cd 0
  git init
  echo 'a1' > a
  echo 'b1' > b
  cd ..

  #0d

  cp -r 0 0d
  cd 0d
  mkdir d
  echo da > d/a
  echo db > d/b
  cd ..

  #1

  cp -r 0 1
  cd 1
  git add *
  git commit -m 1
  cd ..

  #1d

  cp -r 0d 1d
  cd 1d
  git add *
  git commit -m 1
  cd ..

  #1u

  cp -r 1 1u
  cd 1u
  echo 'c1' > c
  cd ..

  #1b

  cp -r 1u 1ub
  cd 1ub
  git branch b
  cd ..

  #2

  cp -r 1 2
  cd 2
  echo 'a2' >> a
  echo 'b2' >> b
  git commit -am 2
  cd ..

  #2u

  cp -r 2 2u
  cd 2u
  echo -e 'c1' >> c
  cd ..

  #2b

  cp -r 1u 2b
  cd 2b
  git add c
  git commit -am '2'

  git checkout -b b HEAD~
  echo a2 >> a
  echo '' >> b
  echo d1 > d
  git add d
  git commit -am 'b2'
  git checkout master
  cd ..

  #3

  cp -r 2 3
  cd 3
  echo 'a3' >> a
  echo 'b3' >> b
  git commit -am 3
  cd ..

  #0bare

  mkdir 0bare
  cd 0bare
  git init --bare
  cd ..

  #multi

  mkdir multi
  cp -r 2b multi/a
  cd multi
    git clone --bare a ao
    git clone --bare ao bo
    git clone bo b

    cd a
    git remote add origin ../ao
    cd ..

    cd b
    git remote add upstream ../ao
    cd ..
  cd ..

  #multiu

  mkdir multiu
  cp -r multi/* multiu
  cd multiu
    cd a
    echo e1 > e
    git add e
    git commit -am e
    cd ..

    cd b
    echo f1 > f
    git add f
    git commit -am f
    cd ..
  cd ..

  ##merges

    mkdir 'tmp'
    cd 'tmp'
      git init
      printf '0\n1\n2\n' > 'a'
      printf '0\n1\n2\n' > 'b'
      printf '0\n1\n2\n' > 'c'
      printf '0\n1\n2\n' > 'd'
      git add '.'
      git commit -m '0'
      git branch -m 'master' 'a'
    cd ..

    ##conflict

      # Multi file merge conflict between branches `a` and `b`, before merge.
      # `c` is changed but has no conflict.
      # `d` is unchanged.

      cp -r 'tmp' 'conflict'
      cd 'conflict'
        git checkout -b 'b'
        sed -Ei 's/1/b/' 'a' 'b'
        sed -Ei 's/2/c/' 'c'
        git add '.'
        git commit -m '1'

        git checkout 'a'
        sed -Ei 's/1/a/' 'a' 'b'
        sed -Ei 's/0/c/' 'c'
        git add '.'
        git commit -m '1'
      cd ..

    ##conflict-merge

      # Conflict after `git merge a` and before resolution.

      cp -r 'conflict' 'conflict-merge'
      cd 'conflict-merge'
        git checkout 'b'
        set +e
        git merge 'a'
        set -e
      cd ..

    ##noconflict

      cp -r 'tmp' 'noconflict'
      cd 'noconflict'
        git checkout -b 'b'
        sed -Ei 's/1/b/' 'a' 'b'
        sed -Ei 's/2/c/' 'c'
        git add '.'
        git commit -m '1'

        git checkout 'a'
        sed -Ei 's/1/b/' 'a' 'b'
        sed -Ei 's/0/c/' 'c'
        git add '.'
        git commit -m '1'
      cd ..

    rm -rf 'tmp'
fi
