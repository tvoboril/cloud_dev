# cloud_dev

docker build . -t ubuntu:cloud_dev

docker run --rm -it -v ${PWD}:/developer ubuntu:cloud_dev
