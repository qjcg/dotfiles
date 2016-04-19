# Whitelist Dotfiles

A simple git whitelisting approach to managing dotfiles.


# Requirements

- git
- an `*` in your [`.gitignore`](.gitignore)
- a solid understanding of how to work with git branches
- that's it


# Usage

The master branch contains generic configurations useful accross various
systems, as well as this README.

Create branches for host-groups (e.g. desktop, server) and/or individual hosts
as needed.

Simple is best.


# Sensitive data

The options are:

- don't commit it at all (safest)
- keep it in a private branch, and be very careful only to ever push that branch
  to a private repo on server hardware you own, host, and fully control


# Submodules (optional)

TODO
