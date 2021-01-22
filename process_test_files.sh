#!/bin/bash

if [ -z "$1" ]
then
  OUTPUT_DIR="/github/workspace/Bridge"
else
  OUTPUT_DIR="$1"
fi

mkdir -p ${OUTPUT_DIR}

# process all *.xml files from grupoetra and create index.md
find grupoetra/* -type f -name '*.xml' -exec sh -c '
  set -x
  FILE="$0"
  OUTPUT_DIR="$1"
  DIRNAMEPREFIX=$(dirname "${FILE}")
  DIRNAME=${DIRNAMEPREFIX#"grupoetra/"}
  mkdir -p ${OUTPUT_DIR}/${DIRNAME}
  OUTPUT_FILE_NAME="${OUTPUT_DIR}/${DIRNAME}/index.md"
  echo "Creating markdown file: $OUTPUT_FILE_NAME"
  python3 xml2md.py "$FILE" > "$OUTPUT_FILE_NAME"
' {} ${OUTPUT_DIR} ';'

# process all *.xml files from xml2md-input and create index.md
find xml2md-input/* -type f -name '*.xml' -exec sh -c '
  file="$0"
  OUTPUT_DIR="$1"
  dirnameprefix=$(dirname "${file}")
  DIRNAME=${dirnameprefix#"xml2md-input/"}
  mkdir -p ${OUTPUT_DIR}/${DIRNAME}
  output_file_name="${OUTPUT_DIR}/${DIRNAME}/index.md"
  echo "Creating markdown file: $output_file_name"
  python3 xml2md.py "$file" > "$output_file_name"
' {} ${OUTPUT_DIR} ';'

# cp all the *.png files into the output directory
find xml2md-input/* -type f -name '*.png' -exec sh -c '
  file="$0"
  OUTPUT_DIR="$1"
  basename=$(basename $file)
  dirnameprefix=$(dirname "${file}")
  DIRNAME=${dirnameprefix#"xml2md-input/"}
  output_file_name="${OUTPUT_DIR}/${DIRNAME}/${basename}"
  echo "Creating diagram file: $output_file_name"
  cp $file $output_file_name
' {} ${OUTPUT_DIR} ';'

find "${OUTPUT_DIR}" -type d -exec sh -c '
  DIRPATH=$0
  DIRNAME=$(basename $DIRPATH)
  if [ ! -f "${DIRPATH}/index.md" ]
  then
    if [ ! -f "${DIRPATH}/_index.md" ]
    then
      echo Creating title link for directory: $DIRPATH
      cat > ${DIRPATH}/_index.md <<EOF
---
title: "$DIRNAME"
linkTitle: "$DIRNAME"
weight: 5
---
EOF
    fi
  fi
' {} ${OUTPUT_DIR} ';'
