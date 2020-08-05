
OUTPUT_DIR="/github/workspace/output/"
mkdir -p ${OUTPUT_DIR}

find xml2md-test -type f -name '*.xml' -exec sh -c '
  file="$0"
  OUTPUT_DIR="$1"
  base_name=$(basename "$file")
  echo $base_name
  output_file_name="${OUTPUT_DIR}/${base_name}.md"
  echo $output_file_name
  python3 xml2md.py "$file" > "$output_file_name"
' {} ${OUTPUT_DIR} ';'
