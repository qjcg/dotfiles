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

TODO


# APPENDIX: Useful git commands

I find the following git commands useful with this setup.

```
# print a high-level overview of the differences between branches
git diff --stat branch1 branch2

# rebase branch1 onto master branch (eg: after master has been updated)
git rebase master branch1

# rebase several branches onto master
git rebase --onto master branch1 branch2 ...

# force push all local branches to origin
# useful after local rebasing
git push -f origin --all

# hard-reset local branch1 to match remote origin/branch1
git branch -f branch1 origin/branch1
```
