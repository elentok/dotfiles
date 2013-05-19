Vim
=====

| Category              | Key             | Mode | Action
| -------------------   | -----------     | ---- | ---------
| **Navigation**        | space           | n    | page down
|                       | -               | n    | page up
|                       | ,w              | n    | camelcase word forward
|                       | ,b              | n    | camelcase word backwards
|                       | [q              | n    | previous error
|                       | ]q              | n    | next error
|                       | [n              | n    | previous conflict marker
|                       | ]n              | n    | next conflict marker
|                       | [b              | n    | previous buffer
|                       | ]b              | n    | next buffer
|                       | {               | n    | previous paragraph
|                       | }               | n    | next paragraph
|                       | Ctrl-j,k,l      | i    | move down, up, right
|                       | Ctrl-e          | i    | go to end of line
| **Selection**         | vi&lt;space&gt; | n    | select text between spaces
|                       | vi( / vi{ / vi[ | n    | select text between brackets
|                       | vii             | n    | select text with the same indentation
|                       | vis             | n    | select sentence
|                       | vip             | n    | select paragraph
| **Find**              | enter           | n    | clear search highlight
|                       | *               | n,v  | find current word or visual selection
|                       | ,ff             | n    | find current word with silver searcher
|                       | ,ff             | v    | find current selection with silver searcher
|                       | ,fc             | n    | find code (prompt silver searcher)
|                       | ,fr             | n    | :Gsearch (r = replace)
|                       | ,fg             | n,v  | find in google
|                       | ,fo             | n,v  | find in stack overflow
| **Docs**              | ,dm             | n    | markdown cheatsheet
|                       | ,dj             | n    | jade cheatsheet
|                       | ,dk             | n    | open docs/keys.md
| **Window Management** | ctrl-h,j,k,l    | n    | move to window
|                       | Q               | n    | close or kill window (uses yadr's window killer)
|                       | ,qq             | n    | closes vim (confirms unsaved changes)
|                       | ,sp             | n    | split
|                       | ,sv             | n    | split vertical
| **Go To**             | ,gb             | n    | go to buffer
|                       | ,gc             | n    | go to change
|                       | ,gd             | n    | go to directory
|                       | ,gf             | n    | go to file (CtrlP)
|                       | C-p             | n    | go to file (CtrlP)
|                       | ,gm             | n    | go to most recently used file
|                       | ,gg             | n    | go to nerd tree
|                       | ,gn             | n    | go to nerd tree (and focus current file)
|                       | ,tn             | n    | toggle nerd tree
|                       | C-\             | n    | go to nerd tree (and focus current file)
|                       | ,go             | n    | go to alternate file
|                       | ,gs             | n    | go to snippets file
|                       | ,gt             | n    | go to tag
|                       | ,gv             | n    | go to .vimrc
|                       | ``              | n    | go to tag in current file
| **Editing**           | ctrl-_          | n,i  | toggle hebrew mode
|                       | tab/C-tab       | v    | indent/deindent (without losing selection)
|                       | tab             | i    | autocomplete
|                       | C-j             | i    | expand snippet
|                       | &lt;c-t&gt;     | i    | show available snippets
|                       | C-\             | i    | add ";" to the end of the line
|                       | ,ef             | n    | edit file
|                       | ,et             | n    | edit file in tab
|                       | ,rf             | n    | read file
|                       | ,er             | n    | revert unsaved changes (:e!)
|                       | ,ehs            | n    | split hash
|                       | ,ehj            | n    | join hash
|                       | ,ey             | n    | yank to * and + registers
|                       | ,e=             | n    | tabularize =
|                       | ,e>             | n    | tabularize =>
|                       | ,e:             | n    | tabularize :
|                       | ,e\             | n    | tabularize \                                                     |
|                       | ,e1             | n    | finish line with "#" chars
|                       | ,e2             | n    | finish line with "=" chars
|                       | ,e3             | n    | finish line with "-" chars
|                       | ,cc             | n,v  | comment
|                       | ,cu             | n,v  | uncomment
|                       | ,tw             | n    | toggle word (true/false, on/off)
|                       | crs             | n    | convert to snake_case
|                       | crm             | n    | convert to MixedCase
|                       | crc             | n    | convert to camelCase
|                       | :%S/one/two/    | n    | substitute using [abolish](https://github.com/tpope/vim-abolish)
| **Folding**           | zo              | n    | open fold
|                       | zc              | n    | close fold
|                       | zM              | n    | close all folds
|                       | zR              | n    | open all folds
| **Spelling**          | ,ts             | n    | toggle spelling
|                       | z=              | n    | suggest correct spelling
|                       | zg              | n    | define current word as correctly spelled
|                       | zw              | n    | define current word as wrongly spelled
| **Surround**          | ,#              | n,v  | surround with #{}
|                       | ,"              | n,v  | surround with "
|                       | ,'              | n,v  | surround with '
|                       | ,( or ,)        | n,v  | surround with ()
|                       | ,[ or ,]        | n,v  | surround with []
|                       | ,{ or ,}        | n,v  | surround with {}
| **Git (v=version)*    | ,vd             | n    | git diff
|                       | ,vh             | n    | show history of current file (using tig)
|                       | ,vrf            | n    | revert file changes (git co)
|                       | ,vrp            | n    | revert file changes (interactive, git co -p)
|                       | ,vs             | n    | git status
|                       | ,vaf            | n    | git add {file}
|                       | ,vap            | n    | git add -p (interactive)
|                       | ,vc             | n    | git commit (uses fugitive)
| **Run**               | ,rr             | n    | run current file
|                       | ,rm             | n    | markdown preview
|                       | ,rl             | n    | open selected link
|                       | ,rs             | n    | run selected vim command
|                       | ,rt             | n    | generate tags file
| **Testing**           | ,tf             | n    | test current file
|                       | ,tl             | n    | test current line
|                       | ,tt             | n    | run last test
| **Misc**              | ,,              | n    | redraw
|                       | ,ti             | n    | toggle indent guides


Other Apps
==========

Pixelmator
----------
* v - move
* z - zoom (use alt to zoom out)
* m - rectangular select (marquee)
* h or hold space - hand tool
* cmd+1 - tools
* cmd+2 - layers

iMessages
----------

* Cmd + [,] - previous/next chat
* Cmd + F - go to search bar
* Cmd + F2 - bring to focus

Gmail
----------

* # - delete
* e - archive
* x - select
* v - move to
* gi - go to inbox
