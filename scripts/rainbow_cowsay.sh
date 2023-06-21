#!/bin/bash

# DESCRIPTION:
#   Print a "rainbow coloured random cowsay option" saying something.
#   Note that you need "lolcat" installed to run this. In newer Ubuntu versions, it's in the standard apt repository.
#   Here's the Github to it: https://github.com/busyloop/lolcat
# USAGE:
#   Use the examples below and see the magic happen:
#   ./rainbow_cowsay echo -n "Hello World!"
#   ./rainbow_cowsay fortune
#    To make it run whenever you open your terminal, put a line with a call to this script at the end of your "~/.bashrc".

set -euo pipefail

cows_path=/usr/share/cowsay/cows/

find_args=(-type f -name "*.cow")

# You can add cow exceptions separated by space if needed
# "kiss" is already there because it's kinda awkward
exception_list=(kiss duck)

# Add cow exceptions to find
for exception in "${exception_list[@]}"; do
    find_args+=(! -name "$exception".cow)
done

# Select random cow
random_cow_file=$(find ${cows_path} "${find_args[@]}" | shuf -n 1)

# Remove extension
random_cow=$(basename "${random_cow_file}" .cow)

# Make your input *~fabulous~*
"$@" | cowsay -f "$random_cow" | lolcat

exit 0
