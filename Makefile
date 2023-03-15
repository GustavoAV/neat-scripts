DEFAULT=\033[0m
GREEN=\033[1;32m

DEFAULT_MESSAGE=printf "$(GREEN)Testing $@...$(DEFAULT)\n"
DOCKER_OPTS=-ti --rm -v $(PWD)/scripts:/app -w /app

INSTALL_PKGS_CMDS=/bin/bash -c " \
	./install_pkgs git tree \
	&& git --version \
	&& tree --version \
	"

all: docker_tags install_pkgs standalone_envsubst

docker_tags: scripts/docker_tags
	@$(DEFAULT_MESSAGE)
	@docker run $(DOCKER_OPTS) python:3.11.2-bullseye \
		/bin/bash -c "./$@ alpine"

install_pkgs: scripts/install_pkgs
	@$(DEFAULT_MESSAGE)
	@printf "$(GREEN)Using apt...$(DEFAULT)\n"
	@docker run $(DOCKER_OPTS) debian:bullseye-slim \
		$(INSTALL_PKGS_CMDS)
	@printf "$(GREEN)Using pacman...$(DEFAULT)\n"
	@docker run $(DOCKER_OPTS) archlinux:base \
		$(INSTALL_PKGS_CMDS)
	@printf "$(GREEN)Using yum...$(DEFAULT)\n"
	@docker run $(DOCKER_OPTS) centos:7 \
		$(INSTALL_PKGS_CMDS)

standalone_envsubst: scripts/standalone_envsubst
	@$(DEFAULT_MESSAGE)
	@docker run $(DOCKER_OPTS) alpine:3.17.2 \
		/bin/sh -c "./$@ && envsubst --version"
