# Neat Scripts

Collection of cool and/or useful scripts that I seldom use.

> These weren't heavily tested.
> Their use in production or automated environments is **not** recommended.

## Table of Contents

- [Neat Scripts](#neat-scripts)
  - [Table of Contents](#table-of-contents)
  - [Usage](#usage)
  - [Development](#development)
    - [Template](#template)
    - [Testing](#testing)
    - [Trunk.io](#trunkio)
  - [Useful links](#useful-links)

## Usage

To run the scripts, you have to clone this project and execute:

```bash
chmod +x <filename>           # Give executable permissions to the file
./<filename>                  # Run the script

mv <filename> /usr/local/bin/ # If you want to make it available system wide
```

> Note that these can only run in *nix environments (and maybe WSL, dunno).

## Development

### Template

There is a simple template for new scripts:

```bash
#!/bin/bash

# DESCRIPTION:
#   Small description of the script purpose.
# USAGE:
#   script <arg_1> <arg_2> ... <arg_n>
# BASED ON:
#   https://foo.bar/question

set -euo pipefail
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

main() {
    # Here goes the code
}

main

exit 0
```

### Testing

To test the scripts, you need [Docker](https://docs.docker.com/engine/install/), [Make](https://www.gnu.org/software/make/) and then run:

```bash
make <script-name>
```

Optionally, you can run only `make` (with no arguments) to test all scripts.

### Trunk.io

We recommend [Trunk.io](https://github.com/trunk-io) toolkit to auto format and verify your code.

If you already have it installed, it's gonna detect and use this project `.trunk/` personalized configs.

## Useful links

Generic tips for writing Shell Scripts: [progrium/bashstyle](https://github.com/progrium/bashstyle)
