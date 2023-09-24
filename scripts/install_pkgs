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

pkg_mgr_list="apt-get yum pacman"

# Checks available package manager
check_pkg_mgr() {
    for pkg_mgr in ${pkg_mgr_list}; do
        if command -v "${pkg_mgr}" >/dev/null 2>&1; then
            echo "${pkg_mgr}"
            return
        fi
    done

    echo "Your package manager is not supported!" >&2
    exit 1
}

# Populates "install" and "clean" vars
case $(check_pkg_mgr) in
apt-get)
    install='DEBIAN_FRONTEND=noninteractive \
                && apt-get update -qq \
                && apt-get install -y --no-install-recommends $@'
    clean='apt-get clean \
                && rm -rf /var/lib/apt/lists /var/cache/apt/archives'
    ;;
yum)
    install='yum install -y --setopt=tsflags=nodocs $@'
    clean='yum clean all -y \
                && rm -rf /var/cache/yum'
    ;;
pacman)
    install='pacman -Sy --needed --noconfirm $@'
    clean='pacman -Scc --noconfirm && \
                rm -rf /var/cache/pacman/pkg/*'
    ;;
*) exit 1 ;;
esac

# Runs install retrying if fails
until [ "${n}" -gt "${max}" ]; do
    set +e
    (eval "${install}")
    code=$?
    set -e

    if [ "${code}" -eq 0 ]; then
        break
    fi
    if [ "${n}" -eq "${max}" ]; then
        exit "${code}"
    fi

    echo "Install failed, retrying..."
    n=$((n + 1))
done

# Removes package manager trash
eval "${clean}"

exit 0
