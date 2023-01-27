# Neat Scripts

Collection of cool and/or useful scripts that I seldom use.

> These weren't heavily tested. Their use in production or automated environments is **not** recommended.

## Usage

To run the scripts, you have to clone this project and execute:

```bash
chmod +x <filename>           # Give executable permissions to the file
./<filename>                  # Run the script

mv <filename> /usr/local/bin/ # If you want to make it available system wide
```

> Note that these can only run in *nix environments (and maybe WSL, dunno).

## Development

There is a simple template for new scripts:

```bash
#!/bin/bash

# DESCRIPTION:
#   Small description of the script purpose.
# USAGE:
#   Simple script usage.
# BASED ON:
#   https://foo.bar/question

set -euo pipefail

main() {
    # Here goes the code
}

main

exit 0
```

## Useful links

Generic tips for writing Shell Scripts: [progrium/bashstyle](https://github.com/progrium/bashstyle)
