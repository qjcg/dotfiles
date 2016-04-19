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
