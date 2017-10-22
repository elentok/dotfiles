Command Line Tips
==================

## Find

### delete all files named 'rc.conf':
    find . -name "rc.conf" -exec rm '{}' \;

### delete all empty directories:
    find . -empty -exec rmdir '{}' \;

### run a command on all of the regular files:
    find . -type f -exec clean '{}' \;

## Encryption

### 7z with password:
    7z u -p{password} -mhe target.7z files

### gpg - generate key
    gpg --gen-key

### gpg - export the public key
    gpg --export --armor {email} > gpg-public-key.txt

### gpg -import key
    gpg --import gpg-public-key.txt

### gpg - encrypt using public key
    gpg --encrypt --output encrypted.gpg --recipient {email} {file-to-encrypt}

### gpg - verify sig file

    gpg {file.sig}          # find public key ID
    gpg --recv-key {key-id} # import key
    gpg {file.sig}          # verify signature

## Git

### git undo commit
    git reset --soft HEAD\^

### git revert all changes
    git checkout -f
    or
    git reset --HARD
    
### git point master to origin/master
    git reset --hard origin/master

### git show specific version of file
    git show {branch/tag/commit}:{path/to/file/from/repo/root}   

    example:
      git show master:dir1/dir2/file.txt

### git show orphaned commites
    git reflog --all
    git fsck --lost-found

### git abort merge/cherry-pick
    git reset --merge

### git remove file from repo history
    git filter-branch \ 
      --index-filter 'git rm --cached --ignore-unmatch path/to/file' \
      {from}..{to}

### git delete branch
    git branch -d {branch}
    git push --delete origin {branch}

### git delete tag
    git tag -d {tag}
    git push origin :refs/tags/{tag}

### git remove untracked files
    git clean -f            (all untracked files)
    git clean -f -n         (dry run)
    git clean -f -n {path}  (dry run on files in path)

### git change author

    git rebase -i {tag/commit}
    # mark the commits you want to change with "edit" (or "e")
    # for each commit do:
    git commit --amend --author="Author Name <email@address.com>"
    git rebase --continue

### git checkout remote branch

    git checkout -b {branch} origin/{branch}

### git resolve conflict using theirs

    git co --theirs path/to/file
    git add path/to/file

### git remove dead remote branches

    git remote prune {remote}

### git rebase - run command on each commit

    git rebase -i --exec <build command> <first sha you want to test>~

### git remove submodule

1. Delete module from .gitmodules and stage it (`git add .gitmodules`)
2. Delete the section from .git/config
3. Run

    git rm --cached path/to/submodule
    rm -rf .git/modules/submodule

4. Commit the change
5. Delete the now untracked submodule files (`rm -rf path/to/submodule`).

## ImageMagick

### ImageMagick resize
    convert --sample 50% input.png output.jpg

### ImageMagick convert to 2 colors (2bit, 2-bit)
    convert -colors 2 input.png output.png
### ImageMagick create pdf
    convert file1.png file2.png output.pdf
    convert -page {width}x{height} file1.png file2.png output.pdf

### ImageMagick split pdf to png
    convert -density 200 input.pdf output.png

### ImageMagick flip images
    convert arrow-left.png -flop arrow-right.gif
    convert arrow-up.png   -flip arrow-down.gif


## Awk

### awk - get second column
    awk '{ print $2 }' 

### awk - sum values of 6th column:
    awk '{s+=$6} END { print s }'

### awk - format number with thousand commas (1,000,000)
    awk '{ printf "%''d\n", $1 }' 
    awk "{ printf \"%'d\n\", $1 }" 

## Zsh

### zsh remove extension
    name='file.ext'
    echo ${name:r} # => outputs 'file'

### zsh basename
    fullpath='/path/to/file.ext'
    echo ${fullpath:t} # => outputs 'file.ext'

### zsh regexp
    name='file-bob.txt'
    echo ${name:s/bob/joe} # => outputs 'file-joe.txt'

### zsh rebuild (reindex) autocomplete
    compinit

### zsh read file line by line
    cat $filename | while read line; do echo $line; done

    # to avoid the subshell (so you can access variables outside the loop) you
    # can do this:

    lines=()
    while read line; do lines+=($line); done < $filename
    for line in ${lines[@]}; do ...; done

## Mac

### Fix "There is no connected camera" macbook air problem
    sudo killall VDCAssistant
    (see https://discussions.apple.com/thread/4158054?start=0&tstart=0)

### mac - clear dns cache
    dscacheutil -flushcache

### kext - show loaded modules
    kextstat

### kext - unload module
    sudo kextunload -v -b {bundle-id}

    e.g.

      sudo kextunload -v -b com.FTDI.driver.FTDIUSBSerialDriver

### mac - get app id

    osascript -e 'id of app "Finder"'

    (e.g. for amethyst)


## SQL

### psql show all tables
    psql -h {host} -p {port} -U {username} {database}
    \? - show help (all commands)
    \l - show all databases
    \d - show all tables and other objects
    \dt - show all tables
    \db - show all tablespaces
    \d+ - describe table
    \x {on|off} - turn extended display on/off

## Curl

### curl with cookie
    curl --cookie "cookie_name=cookie_value" http://...

### curl follow redirects
    curl -L http://...

## Google Cloud (gsutil)

### gsutil set public read

    gsutil acl ch -u AllUsers:R gs://bucket/file.txt

## AWS S3

### s3cmd - set public read on all files

    s3cmd setacl 's3://{bucket-name}/{path}/**/*' --acl-public --verbose

### s3cmd - list all files (recursively)

    s3cmd ls 's3://{bucket-name}/{path}' -r

## Vim

### vim sudo tee trick

    :w !sudo tee %

## Crontab

Columns: `minute hour day-of-month month day-of-week command`

Every 30 minutes:

    */30 * * * * the_command

## Go (golang)

Debugging native compilations:

* use "-x" to printout the build flags (e.g. `go get -x {package}`)

## Markdown

### Markdown footnote links

This is a link to [Something][1]

[1]: http://something.com

## Nix

### update (like apt-get update)
    nix-channel --update

### upgrade (like apt-get upgrade)
    nix-env -u

### install package
    nix-env -i {package}

### remove package
    nix-env -e {package}

### find packages
    nix-env -qaP '.*{name}.*'

### show package info
    nix-env -qa --description '.*{name}.*'

## dpkg

### list all packages
    dpkg -l

### search for a package
    dpkg -l '*qt*'

### list files in package
    dpkg -L 'package-name'

## Misc

### lsof - show all used ports
    lsof -i -n -P
    (use sudo to show processes by all users)

### cut prefix
    echo "hello" | cut -c 3- # will output "llo"

### reset terminal
    ctrl+c reset
    ctrl+c stty sane

### count number of lines
    wc -l

### format xml
    cat file.xml | xmllint --format -

### hex view
    od -xcb {file}

### irc - register nick
    /msg nickserv help
    /msg nickserv register <password> <email-address>

### bzr - pull repository
    bzr branch bzr+ssh://{username}@{hostname}/path/to/repo local_dir_to_create

### tmux - detach all other clients
    tmux attach -d
    tmux attach -d -t specific_session_name

### which ubuntu version am I running
    lsb_release -a

### diff directories

    # show only summary (e.g. "file1 differs"):
    diff -rq dirA dirB

    # show diff for each file:
    diff -r dirA dirB

## change ubuntu/debian default terminal

    sudo update-alternatives --config x-terminal-emulator
