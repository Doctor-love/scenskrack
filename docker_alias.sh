alias scenskrack='mkdir -p output; docker run --tty --interactive --rm --network none --volume "${PWD}:/input" --volume "${PWD}/output:/output" "scenskrack:${SCENSKRACK_IMAGE_TAG:-latest}"'
