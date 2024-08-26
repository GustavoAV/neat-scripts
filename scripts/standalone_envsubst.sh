#!/bin/sh

# DESCRIPTION:
#   Installs the "gettext" package, which constains the widely useful "envsubst" command and removes the other stuff it brings together.
# USAGE:
#   This is supposed to be used in Alpine docker images to get the smallest possible version of the command.
#   Here's a simple comparison of the final image size after the cleanup.
#   IMAGE     TAG      SIZE
#   alpine    3.16.3   5.54MB   # Base image
#   envsubst  normal   11.9MB   # Just "apk add --no-cache-envsubst"
#   envsubst  smaller  5.65MB   # Using this script
# BASED ON:
#   https://github.com/nginxinc/docker-nginx/blob/5ce65c3efd395ee2d82d32670f233140e92dba99/mainline/alpine-slim/Dockerfile#:~:text=Bring%20in%20gettext,the%20rest%20away

set -eu

# Install "gettext"
apk add --no-cache --virtual .gettext gettext

# Move "envsubst" out of the way
mv /usr/bin/envsubst /tmp/
runDeps="$(
    scanelf --needed --nobanner /tmp/envsubst |
        awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' |
        sort -u |
        xargs -r apk info --installed |
        sort -u
)"

# Delete "gettext" completely
# trunk-ignore(shellcheck/SC2086)
apk add --no-cache ${runDeps}
apk del .gettext

# Move "envsubst" back
mv /tmp/envsubst /usr/local/bin/

exit 0
