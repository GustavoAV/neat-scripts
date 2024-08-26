DOCKER_RUN := docker run --rm -v $(PWD)/scripts:/app -w /app

ALPINE_IMAGE := alpine:3.17.2
ARCHLINUX_IMAGE := archlinux:base
CENTOS_IMAGE := centos:7
DEBIAN_IMAGE := debian:bookworm-slim
PYTHON_IMAGE := python:3.11.4-bookworm
UBUNTU_SYSTEMD_IMAGE := geerlingguy/docker-ubuntu2404-ansible:latest

all: docker_tags.sh install_pkgs.sh random_cowsay.sh standalone_envsubst.sh vagrant_box_setup.sh

docker_tags.sh:
	$(DOCKER_RUN) $(PYTHON_IMAGE) ./$@ alpine

install_pkgs.sh:
	$(DOCKER_RUN) $(DEBIAN_IMAGE) ./$@ tree
	$(DOCKER_RUN) $(ARCHLINUX_IMAGE) ./$@ tree
	$(DOCKER_RUN) $(CENTOS_IMAGE) ./$@ tree

random_cowsay.sh:
	$(DOCKER_RUN) $(PYTHON_IMAGE) /bin/bash -c ' \
		export PATH="$$HOME/.local/bin/:$$PATH" \
		&& pip install --user cowsay lolcat \
		&& ./$@ | lolcat'

standalone_envsubst.sh:
	$(DOCKER_RUN) $(ALPINE_IMAGE) /bin/sh -c "./$@ && envsubst --version"

vagrant_box_setup.sh:
	$(DOCKER_RUN) $(UBUNTU_SYSTEMD_IMAGE) ./$@

.PHONY: docker_tags.sh install_pkgs.sh random_cowsay.sh standalone_envsubst.sh vagrant_box_setup.sh
