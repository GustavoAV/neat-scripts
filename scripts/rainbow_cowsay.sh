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

dependencies_check() {
    for dependency in "$@"; do
        if ! command -v "${dependency}" > /dev/null 2>&1; then
            echo "${dependency} is not installed!" >&2
            exit 1
        fi
    done
}

dependencies_check cowsay lolcat

cows_dir=/usr/share/cowsay/cows/
find_args=(-type f -name "*.cow")

# You can add cow exceptions separated by space if needed
# "kiss" is already there because it's kinda awkward
exception_list=(kiss)

# Add cow exceptions to find
for exception in "${exception_list[@]}"; do
    find_args+=(! -name "$exception".cow)
done

# Select random cow
random_cow_file=$(find ${cows_dir} "${find_args[@]}" | shuf -n 1)

# Remove extension
random_cow=$(basename "${random_cow_file}" .cow)

# When provided arguments, echoes the input
if [[ $# -gt 0 ]]; then
    echo "$@" | cowsay -f "$random_cow" | lolcat
else
    fortune -s | cowsay -f "$random_cow" | lolcat
fi

exit 0
