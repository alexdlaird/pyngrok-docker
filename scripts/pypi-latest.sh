#!/usr/bin/env bash

PYTHON_BIN=${PYTHON_BIN:-python}

# Prefer ggrep, if it's installed (required on Mac)
which ggrep > /dev/null
if [ $? -eq 0 ]; then
  GREP_BIN=ggrep
else
  GREP_BIN=grep
fi

echo "$($PYTHON_BIN -m pip index versions pyngrok | $GREP_BIN -oP 'Available versions: \K[0-9\.]*').0"
