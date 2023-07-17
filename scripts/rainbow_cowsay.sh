#!/bin/bash

# DESCRIPTION:
#   Print a "rainbow coloured random cowsay option" saying something.
#   Note that you need "lolcat" installed to run this. In newer Ubuntu versions, it's in the standard apt repository.
#   Here's the Github to it: https://github.com/busyloop/lolcat
# USAGE:
#   Use the examples below and see the magic happen:
#   ./rainbow_cowsay
#   ./rainbow_cowsay Hello World!
#    To make it run whenever you open your terminal, put a line with a call to this script at the end of your "~/.bashrc".

set -euo pipefail

user=$(whoami)
# Get current user GECOS: https://stackoverflow.com/a/833235
user_fullname=$(getent passwd "$user" | cut -d ':' -f 5)
pip_pkgs_path="$HOME/.local/bin"

if [ $# -gt 0 ]; then
    # Use provided args if present
    cow_string="$*"
else
    # Default string
    cow_string="Hello, $user_fullname!"
fi

dependencies_check() {
    for dependency in "$@"; do
        if [ ! -x "$pip_pkgs_path/$dependency" ]; then
            echo "$dependency is not available!" >&2
            exit 0
        fi
    done
}

random_cowtput() {
    python3 -c \
        "import cowsay, random; \
        random_cow = random.choice(cowsay.char_names); \
        cowtput = cowsay.get_output_string(random_cow, '$cow_string'); \
        print(cowtput)"
}

dependencies_check cowsay lolcat
random_cowtput | lolcat

exit 0
