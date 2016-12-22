elentok's dotfiles
=======================

To install run:

```bash
  $ curl -L https://github.com/elentok/dotfiles/raw/master/online_install.sh | bash
```

by default it will clone the repository from "https://github.com/elentok/dotfiles",
to use ssh run this:

```bash
  $ curl -L https://github.com/elentok/dotfiles/raw/master/online_install.sh | bash -s use-ssh
```

## Documentation

* [keys.md](docs/keys.md) - a cheatsheet of all of my vim keybindings
  (can be accessed from the command line using the `k` command)
* [help.md](docs/help.md) - a cheatsheet of useful commands
  (can be accessed from the command line using the `h` or `h {query}` commands)
* [commands.md](docs/commands.md) - a cheatsheet of of my custom shell scripts

Customization
--------------

You can customize the settings by putting the following files in the ~/.dotlocal directory.

### Git

Use `~/.dotlocal/gitconfig`:

```gitconfig
[user]
  name = Your Name
  email = you@gmail.com
[github]
  user = your-github-user
```

### Zsh settings & aliases

You can use the following files to customize your zsh settings:

* `~/.dotlocal/zsh/core.zsh` - runs on all sessions (both login and non-login)
* `~/.dotlocal/zsh/before.zsh` - runs at the beginning of all login sessions
  (right after core.zsh)
* `~/.dotlocal/zsh/after.zsh` - runs at the end of all of all login sessions

### Vim

* Add custom plugins to `~/.dotlocal/plugs.vim`
* Add custom settings to `~/.dotlocal/before.vim` or `~/.dotlocal/after.vim`

Basic Vim Setup
---------------

To install my basic vim setup (without any plugins and should work on old
versions of vim):

```
curl https://raw.githubusercontent.com/elentok/dotfiles/master/vim/basic.vim > ~/.vimrc
```
