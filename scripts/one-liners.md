# One Liners

This contains some simpler commands, not scripts, that are helpful.

## lsb_release alternative

In install tutorials, it's common to have `lsb_release -cs` to get the Distro codename like "jammy", "bullseye" or sth like this.However, in Linux Mint, this returns Mint's codename, for which most repositories don't contain specific versions. This command gets the relative Ubuntu version in which Mint is based.

```bash
codename=$(sed --quiet "s/UBUNTU_CODENAME=//p" /etc/os-release)
```
