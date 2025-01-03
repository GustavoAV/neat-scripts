# One Liners

This contains some simpler commands, not scripts, that are helpful.

## Table of Contents

- [One Liners](#one-liners)
  - [Table of Contents](#table-of-contents)
  - [Maven via Docker](#maven-via-docker)
  - [lsb\_release alternative](#lsb_release-alternative)
  - [HTTP responde status code only](#http-responde-status-code-only)
  - [Create SSH Key without prompt](#create-ssh-key-without-prompt)

## Get interfaces name and IP only

The command `ip a` shows information about your machine networks, but contains a little too much info that you might not need. To get only the interfaces name and IP, run this.

```bash
# ip: Show interfaces info in oneline
# tr: Removes duplicate spaces
# cut: Separate collumns by space and shows only specific ones
ip -o address | tr -s " " | cut -d " " -f 2,4
```

## Maven via Docker

Run Maven via Docker, mapping your current path to the container and reusing your local dependencies (from the `~/m2/` directory). This is specially useful when you have multiple Java projects.

```bash
docker run --rm \
    -e MAVEN_CONFIG=/var/maven/.m2 \
    -u $(id -u):$(id -g) \
    -v $(pwd):/app \
    -v ~/.m2/:/var/maven/.m2/ \
    -w /app \
    maven:3.9.0-eclipse-temurin-11 \
    mvn clean package
```

## lsb_release alternative

In install tutorials, it's common to have `lsb_release -cs` to get the Distro codename like "jammy", "bullseye" or sth like this. However, in Linux Mint, this returns Mint's codename, for which most repositories don't contain specific versions. This command gets the relative Ubuntu version in which Mint is based.

```bash
codename=$(sed --quiet "s/UBUNTU_CODENAME=//p" /etc/os-release)
```

## HTTP responde status code only

Gets only the status code of a http request. You can use this in a script to, for example, check if your repository already contains some component.

```bash
status_code=$(
    curl
        --head
        --insecure
        --location
        --output /dev/null
        --silent
        --user "${CI_REGISTRY_USER}:${CI_REGISTRY_PASSWORD}"
        --write-out "%{http_code}"
        "https://${CI_REPOSITORY}/repository/maven-releases/foo/bar.jar"
)
```

## Create SSH Key without prompt

This creates a ssh key pair with `ssh-keygen` with no passphrase, prompt and output.

Note that this is objectively not apropriate for production environments, just for development in your machine.

```bash
cat /dev/zero | ssh-keygen -f ./sample_rsa -C "sample" -q -N ""
```
