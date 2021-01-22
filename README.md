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
In the following commands, $(repo_owner) will either be smart-grid-use-cases or
your github username, if you wish to download the dependency from a fork.

    mkdir Bridge
    ./get_latest.sh $(repo_owner) excel2xml grupoetra.zip grupoetra
    ./get_latest.sh $(repo_owner) xml2md-input Release.zip xml2md-input
    ./process_test_files.sh Bridge
