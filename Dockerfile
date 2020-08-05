from alpine:latest

run apk add python3
run pip3 install chevron xmltodict
copy . /xml2md
workdir /xml2md
cmd /xml2md/process_test_files.sh
