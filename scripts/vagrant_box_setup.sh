#!/usr/bin/env bash

# DESCRIPTION
#   Sets up necessary packages and configs for Vagrant integration in a Ubuntu system.
#   After running this, you are ready to import this into a Vagrant box.
# USAGE
#   sudo ./vagrant_box_setup
# BASED ON
#   https://developer.hashicorp.com/vagrant/docs/boxes/base

set -euo pipefail

info() {
    timestamp=$(date +'%F-%H%M%S')
    echo "$timestamp [INFO]" "$@"
}

install_pkgs() {
    info "Installing packages"

    apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wget \
        openssh-server \
        linux-headers-"$(uname -r)" \
        build-essential \
        dkms
    
    info "Apt trash cleaning"

    apt-get clean -y
    apt-get autoremove -y
    rm -rf /var/lib/apt/lists/*
}

vagrant_user() {
    info "Creating vagrant group and user"

    if ! getent group vagrant >/dev/null 2>&1; then
        groupadd vagrant
    fi
    if ! getent passwd vagrant >/dev/null 2>&1; then
        useradd --create-home --gid vagrant --shell /bin/bash vagrant
        echo "vagrant:vagrant" | chpasswd
    fi
}

import_key() {
    info "Importing Vagrant key"

    install -m 0700 -d /home/vagrant/.ssh/
    wget -qO /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub
    chmod 0600 /home/vagrant/.ssh/authorized_keys
    chown --recursive vagrant:vagrant /home/vagrant/.ssh/
}

sudoers_config() {
    info "Sudoers config"

    echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant
    chmod 0440 /etc/sudoers.d/vagrant
    sed -i "s|^requiretty|# requiretty|" /etc/sudoers
    visudo --check
}

sshd_config() {
    info "Sshd config"

    systemctl enable ssh
    echo 'UseDNS no' > /etc/ssh/sshd_config.d/vagrant
    install -d /run/sshd
    sshd -t
}

install_pkgs
vagrant_user
import_key
sudoers_config
sshd_config

info "Setup complete!"
