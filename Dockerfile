# This is a comment
# This is a comment
FROM littlemole/devenv_gpp_make
MAINTAINER me <little.mole@oha7.org>

# std dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential g++ \
libgtest-dev cmake git pkg-config valgrind sudo joe wget \
clang libc++-dev libc++abi-dev libexpat-dev

ARG CXX
ENV CXX=${CXX}

# compile gtest with given compiler
RUN cd /usr/src/gtest && \
  if [ "$CXX" = "g++" ] ; then \
    cmake .; \
  else \
  cmake -DCMAKE_CXX_COMPILER=$CXX -DCMAKE_CXX_FLAGS="-std=c++14 -stdlib=libc++" . ; \
  fi && \
  make 
 # ln -s /usr/src/gtest/libgtest.a /usr/lib/libgtest.a

RUN mkdir -p /usr/local/src/patex
ADD . /usr/local/src/patex

ARG BUILDCHAIN=make
ENV BUILDCHAIN=${BUILDCHAIN}

RUN echo -e $CXX

RUN /usr/local/src/patex/docker/run.sh
