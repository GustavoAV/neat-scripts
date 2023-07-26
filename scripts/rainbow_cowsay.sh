#!/bin/bash

# DESCRIPTION:
#   Print a "rainbow coloured random cowsay option" saying something.
#   You can install the dependencies with "pip install --user cowsay lolcat"
# USAGE:
#   Use the examples below and see the magic happen:
#   ./rainbow_cowsay
#   ./rainbow_cowsay Hello World!
#   To make it run whenever you open your terminal, put a line with a call to this script at the end of your "~/.bashrc".

set -euo pipefail

# If present, use provided cli args
# Else, get user name
if [ $# -gt 0 ]; then
    cow_string="$*"
else
    user=$(whoami)
    # Get current user GECOS: https://stackoverflow.com/a/833235
    user_fullname=$(getent passwd "$user" | cut --delimiter=':' --fields=5)
    cow_string="Hello, $user_fullname!"
fi

dependencies_check() {
    for dependency in "$@"; do
        if ! command -v "$dependency" >/dev/null 2>&1; then
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
