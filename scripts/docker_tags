#!/bin/bash

# DESCRIPTION:
#   Get all tags of said docker image.
#   Before execution, it checks if curl/wget and python are available.
# USAGE:
#   docker-tags <image-name>
# BASED ON:
#   https://stackoverflow.com/a/48931329

set -euo pipefail
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

name="$1"

# If "name" doesn't contain a slash, defaults to "library/name"
if [[ "$name" =~ "/" ]]; then
    repository="$name"
else
    repository="library/$name"
fi

url="https://registry.hub.docker.com/v2/repositories/$repository/tags/?page_size=100"

dependencies_check() {
    # Is "curl" or "wget" available?
    if command -v curl &>/dev/null; then
        download_cmd='curl -s'
    elif command -v wget &>/dev/null; then
        download_cmd='wget -qO-'
    else
        echo "Curl or wget is not installed!" >&2
        exit 1
    fi

    # Is "python" available? Which version?
    if command -v python3 &>/dev/null; then
        py_bin="$(command -v python3)"
    elif command -v python &>/dev/null; then
        py_bin="$(command -v python)"
    else
        echo "Python is not installed!" >&2
        exit 1
    fi
}

# Save python script to temporary file
cat << 'EOF' > /tmp/json_process.py
import sys, json
data = json.load(sys.stdin)
print(data.get("next", "") or "")
print("\n".join([x["name"] for x in data["results"]]))
EOF

main() {
    (
        # Keep looping until the variable URL is empty
        while [[ -n $url ]]; do
            # Every iteration of the loop prints out a single dot to show progress as it got through all the pages (this is inline dot)
            >&2 echo -n "."
            # Curl the URL and pipe the output to Python. Python will parse the JSON and print the very first line as the next URL (it will leave it blank if there are no more pages)
            # then continue to loop over the results extracting only the name; all will be stored in a variable called content
            content=$( $download_cmd "$url" | $py_bin /tmp/json_process.py )
            # Let's get the first line of content which contains the next URL for the loop to continue
            url=$(echo "$content" | head -n 1)
            # Print the content without the first line (yes +2 is counter intuitive)
            echo "$content" | tail -n +2
        done;
        # Finally break the line of dots
        >&2 echo
    ) | cut -d '-' -f 1 | sort -V | uniq;

    # Remove python script file
    rm /tmp/json_process.py
}

dependencies_check

main "$@"

exit 0
