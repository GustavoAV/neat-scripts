# One Liners

This contains some simpler commands, not scripts, that are helpful.

## lsb_release alternative

In install tutorials, it's common to have `lsb_release -cs` to get the Distro codename like "jammy", "bullseye" or sth like this.However, in Linux Mint, this returns Mint's codename, for which most repositories don't contain specific versions. This command gets the relative Ubuntu version in which Mint is based.

```bash
codename=$(sed --quiet "s/UBUNTU_CODENAME=//p" /etc/os-release)
```

## HTTP responde status code only

Gets only the status code of a http request. You can use this to, for example, check if your repository already contains some component.

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
