#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user

mkdir -p /deps /deps-build /go/pkg

# Setup our required directories
chown -R $USER_ID:$USER_ID /deps /deps-build
chown $USER_ID:$USER_ID / /go/pkg /go/bin /usr/local/go/pkg

exec /usr/local/bin/gosu user /build.sh "$@"
