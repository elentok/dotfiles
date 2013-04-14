elentok's dotfiles
=======================

To install run:

```bash
  $ curl -L https://github.org/elentok/dotfiles/raw/master/online_install.sh | bash
```

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

Use `~/.dotlocal/zshrc.after` or `~/.dotlocal/zshrc.before`.

### Vim

* Add custom vundles to `~/.dotlocal/vundles.vim`
* Add custom settings to `~/.dotlocal/after.vim`
