#!/usr/bin/env python3

"""
DESCRIPTION
  Prints a random cowsay option saying something.
  Use it with lolcat to make things look *~fabulous~*.
  You can install the dependencies with "pip install --user cowsay lolcat"

USAGE
  random_cowsay
  random_cowsay | lolcat
  random_cowsay "Hello World!"
  random_cowsay "Hello World!" | lolcat

TIP
  To make it run whenever you open your terminal, put a line with a call to
  this script at the end of your "~/.bashrc".
"""

import os
import pwd
import random
import sys

import cowsay


def main(arg_list):
    """
    Prints random cowsay

    If provided, use cli args as the input
    Else, gets user full name
    """
    if len(arg_list) > 0:
        cow_string = " ".join(arg_list)
    else:
        # Get current OS user full name: https://stackoverflow.com/a/15031204
        user_full_name = pwd.getpwuid(os.getuid()).pw_gecos.split(",")[0]
        cow_string = f"Hello, {user_full_name}!"

    # trunk-ignore(bandit/B311)
    random_cow = random.choice(cowsay.char_names)
    cowtput = cowsay.get_output_string(random_cow, cow_string)

    print(cowtput)


if __name__ == "__main__":
    # Ignore "sys.argv[0]" since it's the script name
    main(sys.argv[1:])
