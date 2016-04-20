# Dotfiles

A simple git whitelisting approach to managing dotfiles.


# Requirements

- git
- an `*` in your [`.gitignore`](.gitignore)
- a solid understanding of how to work with git branches
- that's it


# Usage

The `master` branch contains generic configurations useful accross various
systems.

Create other branches as needed for host (or host-group) specific
configurations. These branches should be rebased onto the `master` branch when
the `master` branch is updated.

Simple is best.


# Sensitive data

The options are:

- don't commit it at all (safest)
- keep it in a private branch and only ever push that branch to a private repo
  on server hardware you own, host, and fully control


# Submodules (optional)

TODO


# Workflow examples

## Starting from a new HOME

Don't use the dotfiles from this repo, start from scratch:

```shell
# initial setup
git init
echo '*' > .gitignore
git add .gitignore
git commit -m 'Initial commit'

# whitelisting a file / dir
git add -f .bash_profile
git commit -m 'Add .bash_profile'
```

Use the dotfiles from this repo in your new HOME:

```shell
cd
git init
git add remote origin https://github.com/qjcg/dotfiles
git remote update
git checkout -b master origin/master
```




# APPENDIX: Useful git commands

I find the following git commands useful with this setup.

```shell
# rebase branch1 onto master branch (eg: after master has been updated)
git rebase master branch1

# hard-reset local branch1 to match remote origin/branch1
git branch -f branch1 origin/branch1

# hard-reset _currently-checked-out_ branch2 to match remote origin/branch2
git checkout -B branch2 origin/branch2

# force push all local branches to origin
# useful after local rebasing
git push -f origin --all

# print a high-level overview of the differences between branches
git diff --stat branch1 branch2

```
