DOCKER_OPTS=-ti --rm -v $(PWD)/scripts:/app -w /app

INSTALL_PKGS_CMDS=/bin/sh -c " \
	./install_pkgs.sh git tree \
	&& git --version \
	&& tree --version \
	"

all: docker_tags.sh install_pkgs.sh standalone_envsubst.sh

.PHONY: docker_tags.sh
docker_tags.sh:
	docker run $(DOCKER_OPTS) python:3.11.2-bullseye /bin/sh -c "./$@ alpine"

.PHONY: install_pkgs.sh
install_pkgs.sh:
	docker run $(DOCKER_OPTS) debian:bullseye-slim $(INSTALL_PKGS_CMDS)
	docker run $(DOCKER_OPTS) archlinux:base $(INSTALL_PKGS_CMDS)
	docker run $(DOCKER_OPTS) centos:7 $(INSTALL_PKGS_CMDS)

.PHONY: standalone_envsubst.sh
standalone_envsubst.sh:
	docker run $(DOCKER_OPTS) alpine:3.17.2 \
		/bin/sh -c "./$@ && envsubst --version"
