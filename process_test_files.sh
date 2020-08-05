
find xml2md-test -type f -name '*.xml' -exec sh -c '
  for file do
    base_name=$(basename "$file")
    echo $base_name
    output_file_name="output/${base_name}.md"
    echo $output_file_name
    python3 xml2md.py "$file" > "$output_file_name"
  done
' exec-sh {} +
