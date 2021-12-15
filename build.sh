#!/bin/sh -eu

# update in Dockerfiles
ORGANIZATION=altlinux
BRANCHES="p9 p10 sisyphus"
LATEST=p10

at_exit() {
    git checkout master
}
trap 'at_exit $?' EXIT
trap 'exit 143' HUP QUIT PIPE TERM

build_image() {
    image="$1"
    tag="$2"
    dir="$3"

    echo Building "$image:$tag"
    DOCKER_BUILDKIT=1 docker build --rm --tag="$ORGANIZATION/$image:$tag" "$dir"
}

push_image() {
    image="$1"
    tag="$2"

    docker push "$ORGANIZATION/$image:$tag"
}

process_image() {
    image="$1"
    tag="$2"
    dir="$3"

    build_image "$image" "$tag" "$dir"
    push_image "$image" "$tag"

    if [ "$tag" = "$LATEST" ]; then
        build_image "$image" latest "$dir"
        push_image "$image" latest
    fi
}

for branch in $BRANCHES; do
    git checkout "$branch"
    process_image base "$branch" base
    for image in $(find -maxdepth 1 -type d -regex '.*/[a-z0-9]*' -printf '%P\n'); do
        if [ "$image" != base ]; then
            process_image "$image" "$branch" "$image"
        fi
    done
done
