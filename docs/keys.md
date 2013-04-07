Vim
=====

| Category              | Key          | Mode | Action
| -------------------   | -----------  | ---- | ---------
| **Navigation**        | space        | n    | page down
|                       | -            | n    | page up
|                       | ,w           | n    | camelcase word forward
|                       | ,b           | n    | camelcase word backwards
|                       | [q           | n    | previous error
|                       | ]q           | n    | next error
|                       | [n           | n    | previous conflict marker
|                       | ]n           | n    | next conflict marker
|                       | [b           | n    | previous buffer
|                       | ]b           | n    | next buffer
|                       | {            | n    | previous paragraph
|                       | }            | n    | next paragraph
|                       | Alt-j,k,l    | i    | move down, up, right
| **Find**              | enter        | n    | clear search highlight
|                       | *            | n,v  | find current word or visual selection
|                       | ,fw          | n    | find current word with ack-grep
|                       | ,fa          | v    | find current selection with ack-grep
|                       | ,fa          | n    | prompt for search with ack-grep
|                       | ,fr          | n    | :Gsearch (r = replace)
|                       | ,fg          | n,v  | find in google
|                       | ,fo          | n,v  | find in stack overflow
| **Docs**              | ,dm          | n    | markdown cheatsheet
|                       | ,dj          | n    | jade cheatsheet
| **Window Management** | ctrl-h,j,k,l | n    | move to window
|                       | Q            | n    | quit window
|                       | ,sp          | n    | split
|                       | ,sv          | n    | split vertical
| **Go To**             | ,gb          | n    | go to buffer
|                       | ,gc          | n    | go to change
|                       | ,gd          | n    | go to directory
|                       | ,gf          | n    | go to file (CtrlP)
|                       | C-p          | n    | go to file (CtrlP)
|                       | ,gg          | n    | toggle nerd tree
|                       | ,gm          | n    | go to most recently used file
|                       | ,gn          | n    | nerd tree (and focus current file)
|                       | C-\          | n    | nerd tree (and focus current file)
|                       | ,go          | n    | go to alternate file
|                       | ,gs          | n    | go to snippets file
|                       | ,gt          | n    | go to tag
|                       | ,gv          | n    | go to .vimrc
|                       | ``           | n    | go to tag in current file
| **Editing**           | ctrl-_       | n,i  | toggle hebrew mode
|                       | tab/C-tab    | v    | indent/deindent (without losing selection)
|                       | tab          | i    | autocomplete or snippet
|                       | <c-t>        | i    | show available snippets
|                       | ,es          | n    | toggle spelling
|                       | z=           | n    | suggest correct spelling
|                       | ,ef          | n    | edit file
|                       | ,et          | n    | edit file in tab
|                       | ,rf          | n    | read file
|                       | ,ehs         | n    | split hash
|                       | ,ehj         | n    | join hash
|                       | ,ey          | n    | yank to * and + registers
|                       | ,e=          | n    | tabularize =
|                       | ,e:          | n    | tabularize :
|                       | ,e\          | n    | tabularize \                                                     |
|                       | ,e1          | n    | finish line with "#" chars
|                       | ,e2          | n    | finish line with "=" chars
|                       | ,e3          | n    | finish line with "-" chars
|                       | ,cc          | n,v  | comment
|                       | ,cu          | n,v  | uncomment
|                       | crs          | n    | convert to snake_case
|                       | crm          | n    | convert to MixedCase
|                       | crc          | n    | convert to camelCase
|                       | :%S/one/two/ | n    | substitute using [abolish](https://github.com/tpope/vim-abolish)
| **Surround**          | ,#           | n,v  | surround with #{}
|                       | ,"           | n,v  | surround with "
|                       | ,'           | n,v  | surround with '
|                       | ,( or ,)     | n,v  | surround with ()
|                       | ,[ or ,]     | n,v  | surround with []
|                       | ,{ or ,}     | n,v  | surround with {}
| **Git (v=version)*    | ,va          | n    | git add
|                       | ,vd          | n    | git diff
|                       | ,vr          | n    | revert file changes (git co)
|                       | ,vs          | n    | git status
|                       | ,vp          | n    | git add -p
| **Run**               | ,rr          | n    | run current file
|                       | ,rm          | n    | markdown preview
|                       | ,rl          | n    | open selected link
|                       | ,rs          | n    | run selected vim command
|                       | ,rt          | n    | generate tags file
| **Testing**           | ,tf          | n    | test current file
|                       | ,tl          | n    | test current line
|                       | ,tt          | n    | run last test
| **Misc**              | ,,           | n    | redraw


Other Apps
==========

Pixelmator
----------
* v - move
* z - zoom
* m - rectangular select (marquee)

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
