#!/bin/bash

set -o errexit

usage() {
  echo "Usage: $0 <target>"
  echo
  echo "* Target is the target which will be scanned for gcda output in CONFIGURATION_TEMP_DIR"
  echo "* This script is meant to run from an xcode run scripts build phase"
  echo "* You must set RUN_CLI=1 for this script to run"
  exit 1
}

THISDIR=$(dirname "$0")
[[ $THISDIR =~ ^/ ]] || THISDIR="$PWD/$THISDIR"

[ -n "$1" ] || usage
INTERMEDIATES="${CONFIGURATION_TEMP_DIR}/${1}.build/Objects-normal/i386/"
shift

if [ "$RUN_CLI" = "" ]; then
  exit 0
fi

TITLE="${PROJECT_NAME} - ${PRODUCT_NAME}"
OUTPUT_DIR="${PROJECT_DIR}/build/test-coverage/${PRODUCT_NAME}"

mkdir -p "$OUTPUT_DIR"
rm -rf "${OUTPUT_DIR}"

osascript ${THISDIR}/export-coverstory.scpt "${INTERMEDIATES}" "${OUTPUT_DIR}"
