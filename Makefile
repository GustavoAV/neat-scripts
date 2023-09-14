DOCKER_RUN := docker run -ti --rm -v $(PWD)/scripts:/app -w /app

ALPINE_IMAGE := alpine:3.17.2
ARCHLINUX_IMAGE := archlinux:base
CENTOS_IMAGE := centos:7
DEBIAN_IMAGE := debian:bookworm-slim
PYTHON_IMAGE := python:3.11.4-bookworm

all: docker_tags install_pkgs random_cowsay standalone_envsubst

.PHONY: docker_tags
docker_tags:
	$(DOCKER_RUN) $(PYTHON_IMAGE) ./$@ alpine

.PHONY: install_pkgs
install_pkgs:
	$(DOCKER_RUN) $(DEBIAN_IMAGE) ./$@ tree
	$(DOCKER_RUN) $(ARCHLINUX_IMAGE) ./$@ tree
	$(DOCKER_RUN) $(CENTOS_IMAGE) ./$@ tree

.PHONY: random_cowsay
random_cowsay:
	$(DOCKER_RUN) $(PYTHON_IMAGE) /bin/bash -c ' \
		export PATH="$$HOME/.local/bin/:$$PATH" \
		&& pip install --user cowsay lolcat \
		&& ./$@ | lolcat'

.PHONY: standalone_envsubst
standalone_envsubst:
	$(DOCKER_RUN) $(ALPINE_IMAGE) /bin/sh -c "./$@ && envsubst --version"
