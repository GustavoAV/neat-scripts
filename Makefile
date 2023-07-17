DOCKER_RUN := docker run -ti --rm -v $(PWD)/scripts:/app -w /app

all: docker_tags.sh install_pkgs.sh rainbow_cowsay.sh standalone_envsubst.sh

.PHONY: docker_tags.sh
docker_tags.sh:
	$(DOCKER_RUN) python:3.11.4-alpine /bin/sh -c \
		"apk add --no-cache bash && ./$@ alpine"

.PHONY: install_pkgs.sh
install_pkgs.sh:
	$(DOCKER_RUN) debian:bullseye-slim ./$@ tree
	$(DOCKER_RUN) archlinux:base ./$@ tree
	$(DOCKER_RUN) centos:7 ./$@ tree

.PHONY: rainbow_cowsay.sh
rainbow_cowsay.sh:
	$(DOCKER_RUN) python:3.11.4-alpine \
		/bin/sh -c 'set -eux \
		&& export PATH="$$HOME/.local/bin/:$$PATH" \
		&& apk add --no-cache bash \
		&& pip install --user cowsay lolcat \
		&& ./$@'

.PHONY: standalone_envsubst.sh
standalone_envsubst.sh:
	$(DOCKER_RUN) alpine:3.17.2 /bin/sh -c "./$@ && envsubst --version"
