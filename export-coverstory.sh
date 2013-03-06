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

osascript - "${INTERMEDIATES}" "${OUTPUT_DIR}" <<EOF
on run argv

    try
    tell Application "CoverStory"
      activate
    end tell
    on error err
      log "\n\n-- Coverstory not found, download coverstory to export html coverage report"
      return
    end try

    tell application "CoverStory"
        set x to open (item 1 of argv)
        tell x to export to HTML in (item 2 of argv)
    end tell
    
    return "\n\nExported CoverStory HTML to " & "'" & item 2 of argv & "'"
end run
EOF
