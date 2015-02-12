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

## git remove untracked files
    git clean -f            (all untracked files)
    git clean -f -n         (dry run)
    git clean -f -n {path}  (dry run on files in path)

## git change author

    git rebase -i {tag/commit}
    # mark the commits you want to change with "edit" (or "e")
    # for each commit do:
    git commit --amend --author="Author Name <email@address.com>"
    git rebase --continue

## git checkout remote branch

    git checkout -b {branch} origin/{branch}

## git resolve conflict using theirs

    git co --theirs path/to/file
    git add path/to/file

## ImageMagick resize
    convert --sample 50% input.png output.jpg

## ImageMagick convert to 2 colors (2bit, 2-bit)
    convert -colors 2 input.png output.png
## ImageMagick create pdf
    convert file1.png file2.png output.pdf
    convert -page {width}x{height} file1.png file2.png output.pdf

## ImageMagick split pdf to png
    convert -density 200 input.pdf output.png

## ImageMagick flip images
    convert arrow-left.png -flop arrow-right.gif
    convert arrow-up.png   -flip arrow-down.gif

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
## zsh rebuild (reindex) autocomplete
    compinit

## tmux - detach all other clients
    tmux attach -d
    tmux attach -d -t specific_session_name
## bzr - pull repository
    bzr branch bzr+ssh://{username}@{hostname}/path/to/repo local_dir_to_create
## irc - register nick
    /msg nickserv help
    /msg nickserv register <password> <email-address>
## Fix "There is no connected camera" macbook air problem
    sudo killall VDCAssistant
    (see https://discussions.apple.com/thread/4158054?start=0&tstart=0)

## format xml
    cat file.xml | xmllint --format -
## hex view
    od -xcb {file}
## mac - clear dns cache
    dscacheutil -flushcache
## bash - read file line by line
    cat $filename | while read line; do echo $line; done

## psql show all tables
  psql -h {host} -p {port} -U {username} {database}
  \? - show help (all commands)
  \l - show all databases
  \d - show all tables and other objects
  \dt - show all tables
  \db - show all tablespaces
  \d+ - describe table
  \x {on|off} - turn extended display on/off
  

## cut prefix
  echo "hello" | cut -c 3- # will output "llo"

## curl with cookie
  curl --cookie "cookie_name=cookie_value" http://...

## curl follow redirects
  curl -L http://...

## which ubuntu version am I running
  lsb_release -a

## lsof - show all used ports
  lsof -i -n -P
  (use sudo to show processes by all users)
