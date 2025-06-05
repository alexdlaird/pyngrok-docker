#!/usr/bin/env bash

PYTHON_BIN=${PYTHON_BIN:-python}
RETRIES="${RETRIES:-30}"
WAIT_TIME="${WAIT_TIME:-10}"

if [[ "${VERSION}" == "" ]]; then echo "VERSION is not set" & exit 1 ; fi

for ((i=0; i<RETRIES; ++i)); do
  if $PYTHON_BIN -m pip index versions pyngrok | grep -i "Available versions: $VERSION" > /dev/null; then
    break
  fi

  echo "Waiting for pyngrok==$VERSION to be available on PyPI ..."
  sleep "$WAIT_TIME"

  (( RETRY_COUNT+=1 ))
done

echo "pyngrok==$VERSION found on PyPI, waiting 10 minutes for cache disbursement ..."
sleep 600
