# Neat Scripts

Collection of cool and/or useful scripts that I seldom use.

> These weren't heavily tested.
> Their use in production or automated environments is **not** recommended.

- [Neat Scripts](#neat-scripts)
  - [Usage](#usage)
  - [Development](#development)
    - [Testing](#testing)
    - [Trunk.io](#trunkio)
  - [References](#references)

## Usage

To run the scripts, you need to clone this project and execute:

```bash
cd scripts/
./<filename>         # Run the script

# If you want to make it available system wide
sudo cp <filename> /usr/local/bin/
```

> Note that these can only run in *nix environments (which includes WSL).

## Development

### Testing

To test the scripts, you need [Docker](https://docs.docker.com/engine/install/), [Make](https://www.gnu.org/software/make/) and then run:

```bash
make <script-name>
```

Optionally, you can run only `make` (with no arguments) to test all scripts.

### Trunk.io

We recommend [Trunk.io](https://github.com/trunk-io) toolkit to auto format and verify your code.

If you already have it installed, it's gonna detect and use this project `.trunk/` personalized configs.

## References

- [Generic tips for writing Shell Scripts](https://github.com/progrium/bashstyle)
