ARG BASE_IMAGE=ubuntu:jammy

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    emacs-nox \
    git \
    ca-certificates \
    cmake libvterm-dev libtool pkg-config \
    libpoppler-dev libpoppler-glib-dev \
    build-essential \
  && rm -rf /var/lib/apt/lists/*

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
