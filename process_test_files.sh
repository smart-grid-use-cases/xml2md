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

# process all *.xml files from grupoetra and create index.md
find grupoetra/* -type f -name '*.xml' -exec sh -c '
  file="$0"
  OUTPUT_DIR="$1"
  dirnameprefix=$(dirname "${file}")
  DIRNAME=${dirnameprefix#"grupoetra/"}
  mkdir -p ${OUTPUT_DIR}/${DIRNAME}
  output_file_name="${OUTPUT_DIR}/${DIRNAME}/index.md"
  echo "$output_file_name"
  python3 xml2md.py "$file" > "$output_file_name"
' {} ${OUTPUT_DIR} ';'

# process all *.xml files from xml2md-input and create index.md
find xml2md-input/* -type f -name '*.xml' -exec sh -c '
  file="$0"
  OUTPUT_DIR="$1"
  dirnameprefix=$(dirname "${file}")
  DIRNAME=${dirnameprefix#"xml2md-input/"}
  mkdir -p ${OUTPUT_DIR}/${DIRNAME}
  output_file_name="${OUTPUT_DIR}/${DIRNAME}/index.md"
  echo "$output_file_name"
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
  cp $file $output_file_name
' {} ${OUTPUT_DIR} ';'
