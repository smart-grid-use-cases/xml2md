#!/bin/sh

FILE="$1"
OUTPUT_DIR="$2"
PREFIX="$3"
DIRNAMEPREFIX=$(dirname "${FILE}")
IS_TLD=$(echo ${DIRNAMEPREFIX} | grep "/")
if [ $? -eq 1 ]; then
  DIRNAME=/
else
  DIRNAME=/${DIRNAMEPREFIX#$PREFIX}
fi
mkdir -p "${OUTPUT_DIR}/${DIRNAME}/"
OUTPUT_FILE_NAME="${OUTPUT_DIR}/${DIRNAME}/index.md"
echo "Creating markdown file: $OUTPUT_FILE_NAME"
DEST_DIR=$(dirname "$OUTPUT_FILE_NAME")
python3 xml2md.py "$FILE" > "${OUTPUT_FILE_NAME}"

find "${DIRNAMEPREFIX}" -type f -name '*.png' -exec sh -c '
  FILE="$0"
  DEST_DIR="$1"
  echo "Copying image $FILE to $DEST_DIR"
  cp "$FILE" "$DEST_DIR"
' {} "${DEST_DIR}" ';'
