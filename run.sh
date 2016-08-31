#!/usr/bin/env bash
# This script will run "make ${1:-test}" inside a Docker container.
set -e
script_file="${BASH_SOURCE[0]##*/}"
script_path="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"

PROJECT="go-coding"
PROJECT_IMAGE=`docker images | grep ${PROJECT} | awk '{ print $1; }'`
GITHUB_USER="jasonzhuyx"
SOURCE_PATH="src/github.com/${GITHUB_USER}/${PROJECT}"

cd -P "${script_path}"

if [[ "${PROJECT_IMAGE}" == "${PROJECT}" ]]; then
	echo -e "\nBuilding docker container for ${PROJECT} ..."
	docker build -t ${PROJECT} .
fi

RUN_TARGET="${1:-test}"

echo -e "\nRunning 'make ${RUN_TARGET}' in docker container ..."
docker run --rm -v "${PWD}":/go/${SOURCE_PATH} \
	-e GITHUB_USERNAME \
	-e GITHUB_PASSWORD \
	${PROJECT} bash -c "make ${RUN_TARGET}"
