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

RUN echo -e "BC: $CXX $BUILDCHAIN"

# compile gtest with given compiler
RUN cd /usr/src/gtest && \
  if [ "$CXX" = "g++" ] ; then \
    cmake .; \
  else \
    cmake -DCMAKE_CXX_COMPILER=$CXX -DCMAKE_CXX_FLAGS=-stdlib=libc++ .  ; \
  fi && \
  make && \
  cp /usr/src/gtest/lib/libgtest.a /usr/lib/x86_64-linux-gnu/libgtest.a
  #ln -s /usr/src/gtest/lib/libgtest.a /usr/lib/libgtest.a

RUN mkdir -p /usr/local/src/patex
ADD . /usr/local/src/patex


RUN /usr/local/src/patex/docker/run.sh
