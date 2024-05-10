FROM fedora as base

LABEL MAINTAINER="gvatsal60"
LABEL DESCRIPTION="Build Environment"

RUN dnf -y update &&\
    dnf -y upgrade &&\
    # Install Dev Tools
    dnf -y group install "Development Tools" &&\
    dnf -y install libasan libubsan make cmake3

# Install gtest-v1.14.0
FROM base as gtest
ARG GTEST_VER=v1.14.0
RUN set -x &&\ 
    SRC=/usr/local/src/google-test-${GTEST_VER} &&\
    mkdir -p $SRC && cd $SRC &&\
    curl -Lfs https://github.com/google/googletest/archive/refs/tags/${GTEST_VER}.tar.gz \
    | tar xz -C $SRC --strip-component=1 &&\
    mkdir build  &&\
    cd build && cmake3 ..  &&\
    make -j8 && make install DESDIR=/opt/gtest

ENTRYPOINT ["/bin/bash", "-c"]