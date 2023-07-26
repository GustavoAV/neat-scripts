DOCKER_RUN := docker run -ti --rm -v $(PWD)/scripts:/app -w /app

ALPINE_IMAGE := alpine:3.17.2
ARCHLINUX_IMAGE := archlinux:base
CENTOS_IMAGE := centos:7
DEBIAN_IMAGE := debian:bullseye-slim
PYTHON_IMAGE := python:3.11.4-bookworm

all: docker_tags.sh install_pkgs.sh rainbow_cowsay.sh standalone_envsubst.sh

.PHONY: docker_tags.sh
docker_tags.sh:
	$(DOCKER_RUN) $(PYTHON_IMAGE) ./$@ alpine

.PHONY: install_pkgs.sh
install_pkgs.sh:
	$(DOCKER_RUN) $(DEBIAN_IMAGE) ./$@ tree
	$(DOCKER_RUN) $(ARCHLINUX_IMAGE) ./$@ tree
	$(DOCKER_RUN) $(CENTOS_IMAGE) ./$@ tree

.PHONY: rainbow_cowsay.sh
rainbow_cowsay.sh:
	$(DOCKER_RUN) $(PYTHON_IMAGE) /bin/bash -c ' \
		export PATH="$$HOME/.local/bin/:$$PATH" \
		&& pip install --user cowsay lolcat \
		&& ./$@'

.PHONY: standalone_envsubst.sh
standalone_envsubst.sh:
	$(DOCKER_RUN) $(ALPINE_IMAGE) /bin/sh -c "./$@ && envsubst --version"
