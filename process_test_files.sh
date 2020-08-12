#!/bin/bash

if [ -z "$1" ]
then
  OUTPUT_DIR="/github/workspace/Bridge"
else
  OUTPUT_DIR="$1"
fi

mkdir -p ${OUTPUT_DIR}

cat > ${OUTPUT_DIR}/_index.md <<EOF
---
title: "Bridge"
linkTitle: "Bridge"
weight: 5
---
EOF

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

find xml2md-test/* -type f -name '*.png' -exec sh -c '
  file="$0"
  OUTPUT_DIR="$1"
  basename=$(basename $file)
  dirnameprefix=$(dirname "${file}")
  DIRNAME=${dirnameprefix#"xml2md-test/"}
  output_file_name="${OUTPUT_DIR}/${DIRNAME}/${basename}"
  cp $file $output_file_name
' {} ${OUTPUT_DIR} ';'
