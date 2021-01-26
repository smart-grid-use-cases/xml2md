#!/bin/sh

set -o errexit

if [ -z "$1" ]
then
  OUTPUT_DIR="/github/workspace/Bridge"
else
  OUTPUT_DIR="$1"
fi

mkdir -p ${OUTPUT_DIR}

RUN_XML2MD=$(cat << EOM
  FILE=\$0
  OUTPUT_DIR="\$1"
  PREFIX="\$2"
  DIRNAMEPREFIX=\$(dirname "\${FILE}")
  IS_TLD=\$(echo \${DIRNAMEPREFIX} | grep "/")
  if [ \$? -eq 1 ]; then
    DIRNAME=/
  else
    DIRNAME=/\${DIRNAMEPREFIX#\$PREFIX}
  fi
  mkdir -p "\${OUTPUT_DIR}/\${DIRNAME}/"
  OUTPUT_FILE_NAME="\${OUTPUT_DIR}\${DIRNAME}/index.md"
  echo "Creating markdown file: \$OUTPUT_FILE_NAME"
  python3 xml2md.py "\$FILE" > "\${OUTPUT_FILE_NAME}"
  IMAGES=\$(find "\${DIRNAMEPREFIX}" -iname *.png)
  for IMAGE in \$IMAGES
  do
    echo Copying image file "\$IMAGE" into "\${OUTPUT_DIR}/\${DIRNAME}"
    cp "\$IMAGE" "\${OUTPUT_DIR}/\${DIRNAME}"
  done
EOM
)

# process all *.xml files from grupoetra and create index.md
find grupoetra/* -type f -name '*.xml' -exec sh -c "$RUN_XML2MD" {} ${OUTPUT_DIR} "grupoetra/" ';'

# process all *.xml files from xml2md-input and create index.md
find xml2md-input/* -type f -name '*.xml' -exec sh -c "$RUN_XML2MD" {} ${OUTPUT_DIR} "xml2md-input/" ';'

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
