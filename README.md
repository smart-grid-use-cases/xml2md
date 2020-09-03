# xml2md
Tool to convert use cases in XML format to markdown

## Setup

### Check out examples
git clone git@github.com:smart-grid-use-cases/xml2md-test.git


## Run using docker

### Build container
docker build -t xml2md .
### Run container
docker run -v $(pwd)/output:/xml2md/output xml2md

## Run directly on a linux vm/desktop

### Install dependencies
sudo apt install python3
pip3 install xmltodict chevron

### Run
mkdir output
./process_test_files.sh output
