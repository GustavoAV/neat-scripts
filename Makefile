DOCKER_RUN := docker run --rm -v ./scripts:/app -w /app

ALMALINUX_IMAGE := almalinux:9.4
ALMALINUX_MIN_IMAGE := almalinux:9.4-minimal
ALPINE_IMAGE := alpine:3.20.2
ARCHLINUX_IMAGE := archlinux:base
DEBIAN_IMAGE := debian:bookworm-slim
PYTHON_IMAGE := python:3.12.5-bookworm
UBUNTU_SYSTEMD_IMAGE := geerlingguy/docker-ubuntu2404-ansible:latest

all: docker_tags.sh install_pkgs.sh random_cowsay.sh standalone_envsubst.sh vagrant_box_setup.sh

.PHONY: docker_tags.sh
docker_tags.sh:
	$(DOCKER_RUN) $(PYTHON_IMAGE) ./$@ alpine

.PHONY: install_pkgs.sh
install_pkgs.sh:
	$(DOCKER_RUN) $(DEBIAN_IMAGE) ./$@ tree
	$(DOCKER_RUN) $(ALMALINUX_IMAGE) ./$@ tree
	$(DOCKER_RUN) $(ALMALINUX_MIN_IMAGE) ./$@ tree
	$(DOCKER_RUN) $(ARCHLINUX_IMAGE) ./$@ tree

.PHONY: random_cowsay.sh
random_cowsay.sh:
	$(DOCKER_RUN) $(PYTHON_IMAGE) sh -c 'pip install cowsay lolcat && ./$@ | lolcat'

.PHONY: standalone_envsubst.sh
standalone_envsubst.sh:
	$(DOCKER_RUN) $(ALPINE_IMAGE) sh -c "./$@ && envsubst --version"

.PHONY: vagrant_box_setup.sh
vagrant_box_setup.sh:
	$(DOCKER_RUN) $(UBUNTU_SYSTEMD_IMAGE) ./$@
