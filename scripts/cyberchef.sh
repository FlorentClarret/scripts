#!/bin/bash

PORT="58000"

usage() {
	echo "./cyberchef.sh: "
	echo -e "\tThis script starts a docker container for cyberchef"
	echo "Parameters: "
	echo -e "\t-p|--port: The port you want to use. Default to $PORT"
	echo -e "\t-h|--help: Show this usage"
}

# ================================== Main ==================================

POSITIONAL=()
while [[ $# -gt 0 ]]; do
	case ${1} in
	-p | --port)
		PORT=${2}
		shift
		shift
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		usage
		exit 1
		;;
	esac
	shift
done
set -- "${POSITIONAL[@]}"

if [ "$(docker ps -q -f name=cyberchef)" ]; then
	echo -e "==> Stop the previous docker container"
	docker stop cyberchef
fi

if [ "$(docker ps -aq -f status=exited -f name=cyberchef)" ]; then
	echo -e "==> Remove the previous docker container"
	docker rm cyberchef
fi

echo "==> Update the docker image"
docker pull mpepping/cyberchef

echo "==> Run the container"
docker run -d -p "$PORT:8000" --name cyberchef mpepping/cyberchef

echo "==> Url : http://localhost:$PORT/"

open "http://localhost:$PORT/"
