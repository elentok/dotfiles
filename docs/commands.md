Custom Shell Commands (functions & aliases)
============================================

## Rename (rename)

```bash
  rename 's/query/replacement/g' path/to/files*png
```

## Find file by name (ff)

Finds file containing a given text:

```bash
  ff bob
```

## Git Conflict Resolver (gec)

Opens each conflicted file, allows you to fix the conflict
and asks if you wish to save it

```bash
  gec
```
    
## Git Destroy (git destroy)

Destroys the local and remote branch (confirms before destroying)

```bash
  git destroy {branch-name}
```

## Shell script creator

Creates an executable file with a shebang (#!/bin/bash)

```bash
  newsh {name-of-shell-script}
```
