#!/usr/bin/env bash

PYTHON_BIN=${PYTHON_BIN:-python}
DATE_BIN=${DATE_BIN:-date}
RETRIES="${RETRIES:-30}"
RETRY_WAIT_TIME="${RETRY_WAIT_TIME:-10}"
CACHE_WAIT_TIME="${CACHE_WAIT_TIME:-600}"

if [[ "${VERSION}" == "" ]]; then echo "VERSION is not set" & exit 1 ; fi
# shellcheck disable=SC2046
if [ $(echo "$VERSION" | grep -o "\." | grep -c "\.") != 3 ]; then
  echo "VERSION must have four numbers, be of format x.y.z.a" & exit 1
fi

PYNGROK_VERSION="${VERSION%.*}"

UPLOAD_TIME=""
for ((i=0; i<RETRIES; ++i)); do
  UPLOAD_TIME=$(curl -sf 'https://pypi.org/pypi/pyngrok/json' | jq -r ".releases.\"$PYNGROK_VERSION\"[0].upload_time_iso_8601")
  if [[ "$UPLOAD_TIME" != "" && "$UPLOAD_TIME" != "null" ]]; then
    UPLOAD_TIME=$($DATE_BIN -d "$UPLOAD_TIME" +%s)
    break
  fi
  UPLOAD_TIME=""

  echo "Waiting for pyngrok==$PYNGROK_VERSION to be available on PyPI ..."
  sleep "$RETRY_WAIT_TIME"
done

if [[ "$UPLOAD_TIME" == "" ]]; then
  echo "pyngrok==$PYNGROK_VERSION not found on PyPI after $RETRIES attempts"
  exit 1
fi

echo "pyngrok==$PYNGROK_VERSION found on PyPI"
CURRENT_TIME=$($DATE_BIN "+%s")
ELAPSED_TIME=$(($CURRENT_TIME - $UPLOAD_TIME))
if [ $ELAPSED_TIME -lt $CACHE_WAIT_TIME ]; then
  NEEDED_WAIT=$((CACHE_WAIT_TIME - ELAPSED_TIME))
  echo "Waiting $NEEDED_WAIT more seconds to ensure cache disbursement ..."
  sleep $NEEDED_WAIT
fi
