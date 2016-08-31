#!/usr/bin/env bash
# This script will run "make build" inside a Docker container.
set -e
script_file="${BASH_SOURCE[0]##*/}"
script_path="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"

PROJECT="go-coding"
GITHUB_USER="jasonzhuyx"
SOURCE_PATH="src/github.com/${GITHUB_USER}/${PROJECT}"

cd -P "${script_path}"

echo -e "\nBuilding docker container '${PROJECT}' ..."
docker build -t ${PROJECT} .

echo -e "\nBuilding '${PROJECT}' in docker container ..."
docker run --rm \
  -v "${PWD}":/go/${SOURCE_PATH} \
  -w /go/${SOURCE_PATH} \
  ${PROJECT} bash -c "make build"
