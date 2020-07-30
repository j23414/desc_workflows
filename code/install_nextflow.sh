#! /usr/bin/env bash
# Auth: Jennifer Chang
# Date: 2020/07/23
# Desc: Dependency checked install of nextflow in current folder

set -e
set -u

# Check Java is installed
if [[ -z `which java` ]]; then
    echo "Need to install java"
    exit
fi

# Get version number (\d).(\d)
j_version=`java -version 2>&1 | grep "java version" |tr '"' ' '| awk '{print $3}' `

# If java version is less than 1.8, exit early
if [[ "$j_version" < '1.8' ]]; then
    echo "Need java v1.8 or greater"
    exit
fi

echo "== Java is already installed"
java -version

# Install nextflow if not already installed
if [[ ! -z `nextflow -version` ]]; then
    echo "== Nextflow is already installed"
    nextflow -version
else
    echo "== Installing nextflow to current directory"
    curl -s https://get.nextflow.io | bash
    ./nextflow -version
    ls -ltr nextflow
fi

