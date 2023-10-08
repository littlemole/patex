FROM ubuntu:22.04
MAINTAINER me <little.mole@oha7.org>

# std dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential g++ \
libgtest-dev cmake git pkg-config valgrind sudo joe wget \
clang libc++-dev libc++abi-dev libexpat-dev uuid-dev

ARG CXX
ENV CXX=${CXX}

ARG BUILDCHAIN=make
ENV BUILDCHAIN=${BUILDCHAIN}

ARG WITH_TEST=On
ENV WITH_TEST=${WITH_TEST}

RUN echo -e "BC: $CXX $BUILDCHAIN"

RUN mkdir -p /usr/local/src/patex
ADD . /usr/local/src/patex

# install gtest if not using cmake
RUN /usr/local/src/patex/docker/gtest.sh

RUN /usr/local/src/patex/docker/run.sh
