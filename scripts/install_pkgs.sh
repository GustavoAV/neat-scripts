#!/bin/sh

# DESCRIPTION:
#   Install packages via "apt", "pacman" or "yum" and remove useless stuff.
#   Retries twice if the install fails to avoid failing because of unstable network.
#   You should use this mainly in Docker builds to easily get smaller final images.
# USAGE:
#   install_pkgs <package_1> <package_2> ... <package_n>
# BASED ON:
#   https://github.com/bitnami/containers/blob/main/bitnami/nginx/1.23/debian-11/prebuildfs/usr/sbin/install_packages

set -eu

n=0
max=2

# Selects package manager and respective commands

if command -v apt-get > /dev/null 2>&1; then
    install=' \
        DEBIAN_FRONTEND=noninteractive \
        && apt-get update -qq \
        && apt-get install -y --no-install-recommends $@ \
    '
    clean=' \
        apt-get clean \
        && rm -rf /var/lib/apt/lists /var/cache/apt/archives \
    '
elif command -v pacman > /dev/null 2>&1; then
    install=' \
        pacman -Sy --needed --noconfirm $@ \
    '
    clean=' \
        pacman -Scc --noconfirm \
        && rm -rf /var/cache/pacman/pkg/* \
    '
elif command -v yum > /dev/null 2>&1; then
    install=' \
        yum install -y --setopt=tsflags=nodocs $@ \
    '
    clean=' \
        yum clean all -y \
        && rm -rf /var/cache/yum \
    '
else
    echo "Your package manager is not supported!" >&2
    exit 1
fi

# Runs install retrying if fails.

until [ $n -gt $max ]; do
    set +e
    ( eval "$install" )
    code=$?
    set -e
    if [ $code -eq 0 ]; then
        break
    fi
    if [ $n -eq $max ]; then
        exit $code
    fi
    echo "Install failed, retrying"
    n=$((n + 1))
done

# Removes package manager trash

eval "$clean"
