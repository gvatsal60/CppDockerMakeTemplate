# Use Fedora as the base image
FROM fedora as baseimg

# Metadata indicating the maintainer of this Dockerfile
LABEL MAINTAINER="gvatsal60"
# Description of the purpose of this image
LABEL DESCRIPTION="Build Environment"

# Update and install necessary packages
RUN dnf -y update &&\
    dnf -y upgrade &&\
    # Install Development Tools group and additional dependencies
    dnf -y group install "Development Tools" &&\
    dnf -y install \
    git elfutils-libelf-devel libasan libubsan make cmake3 &&\
    dnf clean all

# Install gtest-v1.14.0
FROM baseimg as gtest
ARG GTEST_VER=v1.14.0
RUN set -x && \
    # Install required packages for compiling and building gtest
    dnf -y install gcc-c++ cmake3 &&\
    dnf clean all && \
    SRC=/usr/local/src/google-test-${GTEST_VER} &&\
    mkdir -p $SRC && cd $SRC &&\
    # Download and extract gtest source code
    curl -Lfs https://github.com/google/googletest/archive/refs/tags/${GTEST_VER}.tar.gz \
    | tar xz -C $SRC --strip-component=1 &&\
    # Create build directory and compile gtest
    mkdir build  &&\
    cd build && cmake3 ..  &&\
    make -j8 && make install DESTDIR=/opt/gtest

# Build Final Image
FROM baseimg as buildimg
# Install necessary packages for the final image
RUN dnf -y install \
    net-tools \
    clang-tools-extra \
    openssl \
    openssl-devel \
    java-11-openjdk \
    gcc \
    gcc-c++ \
    python3 \
    xz &&\
    dnf clean all && \
    dnf -y install glibc-langpack-en

# Copy gtest binaries from the gtest stage
COPY --from=gtest /opt/gtest /

# Set Locale
RUN dnf -y install glibc-langpack-en

# Set environment variables for locale
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# Set Python version
# RUN alternatives --set python /usr/bin/python3

# Define the default command to run when the container starts
ENTRYPOINT ["/bin/bash", "-c"]