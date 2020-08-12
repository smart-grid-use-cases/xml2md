from alpine:latest

run apk update
run apk add python3 py3-pip
run /usr/bin/pip3 install chevron xmltodict
copy . /xml2md
workdir /xml2md
cmd /bin/sh /xml2md/process_test_files.sh
