#!/usr/bin/env bash

PYTHON_BIN=${PYTHON_BIN:-python}
GREP_BIN=${GREP_BIN:-grep}

echo "$($PYTHON_BIN -m pip index versions pyngrok | $GREP_BIN -oP 'Available versions: \K[0-9\.]*').0"