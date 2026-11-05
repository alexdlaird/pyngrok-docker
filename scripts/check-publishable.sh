#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

DOCKER_USERNAME="${DOCKER_USERNAME:-alexdlaird}"
VERSION="${VERSION:-}"

if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "::error::VERSION must have four numbers, be of format x.y.z.a (got '$VERSION')"
  exit 1
fi

STATUS=$(curl -s -o /dev/null -w '%{http_code}' "https://hub.docker.com/v2/repositories/$DOCKER_USERNAME/pyngrok/tags/$VERSION")
case "$STATUS" in
  404) ;;
  200)
    echo "::error::$DOCKER_USERNAME/pyngrok:$VERSION is already published. Bump the fourth number to rebuild it."
    exit 1
    ;;
  *)
    echo "::error::Could not check Docker Hub for $DOCKER_USERNAME/pyngrok:$VERSION (HTTP $STATUS)."
    exit 1
    ;;
esac

LATEST=$(awk '/^\| Container Version /{getline; getline; print $2; exit}' README.md)
if ! [[ "$LATEST" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "::error::Could not read the newest version from the README version map (got '$LATEST')."
  exit 1
fi
if [[ "$(printf '%s\n%s\n' "$LATEST" "$VERSION" | sort -V | tail -1)" != "$VERSION" ]]; then
  echo "::error::$VERSION is older than the newest published version, $LATEST, and would move the floating tags back."
  exit 1
fi

echo "$VERSION can be published (newest so far: $LATEST)."
