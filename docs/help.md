Command Line Tips
==================

## delete all files named 'rc.conf':
    find . -name "rc.conf" -exec rm '{}' \;

## delete all empty directories:
    find . -empty -exec rmdir '{}' \;

## run a command on all of the regular files:
    find . -type f -exec clean '{}' \;

## 7z with password:
    7z u -p{password} -mhe target.7z files

## git undo commit
    git reset --soft HEAD\^

## git revert all changes
    git checkout -f
    or
    git reset --HARD
    
## git point master to origin/master
    git reset --hard origin/master

## git show specific version of file
    git show {branch/tag/commit}:{path/to/file/from/repo/root}   

    example:
      git show master:dir1/dir2/file.txt

## git show orphaned commites
    git reflog --all
    git fsck --lost-found

## git abort merge/cherry-pick
    git reset --merge

## git remove file from repo history
    git filter-branch \ 
      --index-filter 'git rm --cached --ignore-unmatch path/to/file' \
      {from}..{to}

## git delete branch
    git branch -d {branch}
    git push --delete origin {branch}

## ImageMagick resize
    convert --sample 50% input.png output.jpg

## ImageMagick convert to 2 colors (2bit, 2-bit)
    convert -colors 2 input.png output.png
## ImageMagick create pdf
    convert file1.png file2.png output.pdf
    convert -page {width}x{height} file1.png file2.png output.pdf

## reset terminal
    ctrl+c reset
    ctrl+c stty sane

## diff directories

    # show only summary (e.g. "file1 differs"):
    diff -rq dirA dirB

    # show diff for each file:
    diff -r dirA dirB

## awk - get second column
    awk '{ print $2 }' 

## awk - sum values of 6th column:
    awk '{s+=$6} END { print s }'

## awk - format number with thousand commas (1,000,000)
    awk '{ printf "%''d\n", $1 }' 
    awk "{ printf \"%'d\n\", $1 }" 

## count number of lines
    wc -l
## zsh remove extension
    name='file.ext'
    echo ${name:r} # => outputs 'file'
## zsh basename
    fullpath='/path/to/file.ext'
    echo ${fullpath:t} # => outputs 'file.ext'
## zsh regexp
    name='file-bob.txt'
    echo ${name:s/bob/joe} # => outputs 'file-joe.txt'

## tmux - detach all other clients
    tmux attach -d
    tmux attach -d -t specific_session_name
## bzr - pull repository
    bzr branch bzr+ssh://{username}@{hostname}/path/to/repo local_dir_to_create
## irc - register nick
    /msg nickserv help
    /msg nickserv register <password> <email-address>
