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

Use `~/.dotlocal/after.zsh` or `~/.dotlocal/before.zsh`.

### Vim

* Add custom vundles to `~/.dotlocal/vundles.vim`
* Add custom settings to `~/.dotlocal/after.vim`
