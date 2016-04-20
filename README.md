$HOME with .gitignore whitelisting. No symlinks, scripts, or dependencies, just
git.


# Requirements

- git
- an `*` in [`~/.gitignore`](.gitignore)
- that's it


# How it works

## Starting from scratch

```shell
~:$ git init
~:$ echo '*' > .gitignore

# now, you'll need to force-add files you want to track (-f force-adds ignored files)

~:$ git add -f .gitignore
~:$ git commit -m 'Ignore all via .gitignore'

~:$ git add -f .bashrc .tmux.conf .vimrc
~:$ git commit -m 'Add some dotfiles'
```


## Checking out dotfiles on a new system

```shell
~:$ git init
~:$ git remote add origin https://github.com/qjcg/dotfiles
~:$ git remote update
~:$ git checkout -b master origin/master
```


## Different environments, different configurations

Use the `master` branch to keep track of generic config files useful accross
different environments.

You can create other branches as needed for different environments. These
branches can be rebased onto the `master` branch when the `master` branch is
updated.

You might also want to create private branches, only ever pushed to a host
you control, never shared publicly.


## Useful git commands

I find the following git commands useful with this setup.

```shell
# rebase branch1 onto master branch (eg: after master has been updated)
git rebase master branch1

# hard-reset local branch1 to match remote origin/branch1
git branch -f branch1 origin/branch1

# hard-reset _currently-checked-out_ branch2 to match remote origin/branch2
git checkout -B branch2 origin/branch2

# force push all local branches to myremote
# useful after local rebasing
git push -f myremote --all

# print a high-level overview of the differences between branches
git diff --stat branch1 branch2
```
