ARG BASE_IMAGE=alpine:latest

FROM ${BASE_IMAGE}

RUN apk add --no-cache \
    emacs-nox \
    git \
    ca-certificates \
    cmake libvterm-dev libtool pkgconf \
    poppler-dev \
    build-base

# Copy config into the standard emacs config location.
# Encrypted files and tooling metadata are excluded via .dockerignore.
COPY . /root/.config/emacs/

# Pass 1 — install all packages from archives (network required; layer is cached).
# || true: first-time compilation artefacts may cause non-zero exit.
RUN emacs --batch \
      --load /root/.config/emacs/early-init.el \
      --load /root/.config/emacs/init.el \
      2>&1 || true

# Pass 2 — actual boot test: must exit 0.
RUN emacs --batch \
      --load /root/.config/emacs/early-init.el \
      --load /root/.config/emacs/init.el \
      2>&1
