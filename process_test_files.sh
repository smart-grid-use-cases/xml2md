#!/bin/sh

set -o errexit

if [ -z "$1" ]
then
  OUTPUT_DIR="/github/workspace/Bridge"
else
  OUTPUT_DIR="$1"
fi

mkdir -p ${OUTPUT_DIR}

# process all *.xml files from grupoetra and create index.md
find grupoetra/* -type f -name '*.xml' -exec ./run_xml2md.sh {} ${OUTPUT_DIR} "grupoetra/" ';'

# process all *.xml files from xml2md-input and create index.md
find xml2md-input/* -type f -name '*.xml' -exec ./run_xml2md.sh {} ${OUTPUT_DIR} "xml2md-input/" ';'

find "${OUTPUT_DIR}" -type d -exec sh -c '
  DIRPATH=$0
  DIRNAME=$(basename "$DIRPATH")
  if [ ! -f "${DIRPATH}/index.md" ]
  then
    if [ ! -f "${DIRPATH}/_index.md" ]
    then
      echo Creating title link for directory: $DIRPATH with title: $DIRNAME
      cat > "${DIRPATH}/_index.md" <<EOF
---
title: "$DIRNAME"
linkTitle: "$DIRNAME"
weight: 5
---
EOF
    fi
  fi
' {} ${OUTPUT_DIR} ';'
