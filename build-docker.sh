#!/bin/bash -e

<<<<<<< HEAD
DOCKER="docker"
set +e
$DOCKER ps >/dev/null 2>&1
if [ $? != 0 ]; then
=======
BUILD_OPTS="$*"

DOCKER="docker"
set +e
if ! $DOCKER ps >/dev/null 2>&1; then
>>>>>>> upstream/master
	DOCKER="sudo docker"
fi
if ! $DOCKER ps >/dev/null; then
	echo "error connecting to docker:"
	$DOCKER ps
	exit 1
fi
set -e

<<<<<<< HEAD
config_file=()
if [ -f config ]; then
	config_file=("--env-file" "$(pwd)/config")
	source config
fi

=======
if [ -f config ]; then
	source config
fi

while getopts "c:" flag
do
	case "$flag" in
		c)
			# shellcheck disable=SC1090
			source "$OPTARG"
			;;
		*)
			;;
	esac
done

>>>>>>> upstream/master
CONTAINER_NAME=${CONTAINER_NAME:-pigen_work}
CONTINUE=${CONTINUE:-0}
PRESERVE_CONTAINER=${PRESERVE_CONTAINER:-0}

<<<<<<< HEAD
if [ "$*" != "" ] || [ -z "${IMG_NAME}" ]; then
	if [ -z "${IMG_NAME}" ]; then
		echo "IMG_NAME not set in 'config'" 1>&2
		echo 1>&2
	fi
	cat >&2 <<EOF
Usage:
    build-docker.sh [options]
Optional environment arguments: ( =<default> )
    CONTAINER_NAME=pigen_work  set a name for the build container
    CONTINUE=1                 continue from a previously started container
    PRESERVE_CONTAINER=1       keep build container even on successful build
EOF
	exit 1
=======
if [ -z "${IMG_NAME}" ]; then
	echo "IMG_NAME not set in 'config'" 1>&2
	echo 1>&2
exit 1
>>>>>>> upstream/master
fi

CONTAINER_EXISTS=$($DOCKER ps -a --filter name="$CONTAINER_NAME" -q)
CONTAINER_RUNNING=$($DOCKER ps --filter name="$CONTAINER_NAME" -q)
if [ "$CONTAINER_RUNNING" != "" ]; then
	echo "The build is already running in container $CONTAINER_NAME. Aborting."
	exit 1
fi
if [ "$CONTAINER_EXISTS" != "" ] && [ "$CONTINUE" != "1" ]; then
	echo "Container $CONTAINER_NAME already exists and you did not specify CONTINUE=1. Aborting."
	echo "You can delete the existing container like this:"
	echo "  $DOCKER rm -v $CONTAINER_NAME"
	exit 1
fi

$DOCKER build -t pi-gen .
if [ "$CONTAINER_EXISTS" != "" ]; then
<<<<<<< HEAD
	trap "echo 'got CTRL+C... please wait 5s'; $DOCKER stop -t 5 ${CONTAINER_NAME}_cont" SIGINT SIGTERM
	time $DOCKER run --rm --privileged \
		--volumes-from="${CONTAINER_NAME}" --name "${CONTAINER_NAME}_cont" \
		-e IMG_NAME="${IMG_NAME}"\
		pi-gen \
		bash -e -o pipefail -c "dpkg-reconfigure qemu-user-static &&
	cd /pi-gen; ./build.sh;
	rsync -av work/*/build.log deploy/" &
	wait "$!"
else
	trap "echo 'got CTRL+C... please wait 5s'; $DOCKER stop -t 5 ${CONTAINER_NAME}" SIGINT SIGTERM
	time $DOCKER run --name "${CONTAINER_NAME}" --privileged \
		-e IMG_NAME="${IMG_NAME}"\
		"${config_file[@]}" \
		pi-gen \
		bash -e -o pipefail -c "dpkg-reconfigure qemu-user-static &&
	cd /pi-gen; ./build.sh &&
=======
	trap 'echo "got CTRL+C... please wait 5s"; $DOCKER stop -t 5 ${CONTAINER_NAME}_cont' SIGINT SIGTERM
	time $DOCKER run --rm --privileged \
		--volumes-from="${CONTAINER_NAME}" --name "${CONTAINER_NAME}_cont" \
		pi-gen \
		bash -e -o pipefail -c "dpkg-reconfigure qemu-user-static &&
	cd /pi-gen; ./build.sh ${BUILD_OPTS} ;
	rsync -av work/*/build.log deploy/" &
	wait "$!"
else
	trap 'echo "got CTRL+C... please wait 5s"; $DOCKER stop -t 5 ${CONTAINER_NAME}' SIGINT SIGTERM
	time $DOCKER run --name "${CONTAINER_NAME}" --privileged \
		pi-gen \
		bash -e -o pipefail -c "dpkg-reconfigure qemu-user-static &&
	cd /pi-gen; ./build.sh ${BUILD_OPTS} &&
>>>>>>> upstream/master
	rsync -av work/*/build.log deploy/" &
	wait "$!"
fi
echo "copying results from deploy/"
$DOCKER cp "${CONTAINER_NAME}":/pi-gen/deploy .
ls -lah deploy

# cleanup
if [ "$PRESERVE_CONTAINER" != "1" ]; then
<<<<<<< HEAD
	$DOCKER rm -v $CONTAINER_NAME
=======
	$DOCKER rm -v "$CONTAINER_NAME"
>>>>>>> upstream/master
fi

echo "Done! Your image(s) should be in deploy/"
