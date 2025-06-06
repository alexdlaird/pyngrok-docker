#!/usr/bin/env bash

PYTHON_BIN=${PYTHON_BIN:-python}
RETRIES="${RETRIES:-30}"
WAIT_TIME="${WAIT_TIME:-10}"

if [[ "${VERSION}" == "" ]]; then echo "VERSION is not set" & exit 1 ; fi
# shellcheck disable=SC2046
if [ $(echo "$VERSION" | grep -o "\." | grep -c "\.") != 3 ]; then
  echo "VERSION must have four numbers, be of format x.y.z.a" & exit 1
fi

PYNGROK_VERSION="${VERSION%.*}"

for ((i=0; i<RETRIES; ++i)); do
  if $PYTHON_BIN -m pip index versions pyngrok | grep -i "Available versions: $PYNGROK_VERSION" > /dev/null; then
    break
  fi

  echo "Waiting for pyngrok==$PYNGROK_VERSION to be available on PyPI ..."
  sleep "$WAIT_TIME"

  (( RETRY_COUNT+=1 ))
done

echo "pyngrok==$PYNGROK_VERSION found on PyPI, waiting 10 minutes for cache disbursement ..."
sleep 600
