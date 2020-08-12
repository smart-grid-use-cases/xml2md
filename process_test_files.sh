#!/bin/bash

if [ -z "$1" ]
then
  OUTPUT_DIR="/github/workspace/Bridge"
else
  OUTPUT_DIR="$1"
fi

mkdir -p ${OUTPUT_DIR}

find xml2md-test/* -type f -name '*.xml' -exec sh -c '
  file="$0"
  OUTPUT_DIR="$1"
  dirnameprefix=$(dirname "${file}")
  DIRNAME=${dirnameprefix#"xml2md-test/"}
  mkdir -p ${OUTPUT_DIR}/${DIRNAME}
  output_file_name="${OUTPUT_DIR}/${DIRNAME}/index.md"
  echo "$output_file_name"
  python3 xml2md.py "$file" > "$output_file_name"
' {} ${OUTPUT_DIR} ';'
