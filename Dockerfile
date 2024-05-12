# Use Fedora as the base image
FROM fedora as baseimg

# Metadata indicating the maintainer of this Dockerfile
LABEL MAINTAINER="gvatsal60"
# Description of the purpose of this image
LABEL DESCRIPTION="Build Environment"

# Update and install necessary packages
RUN dnf -y update && \
    dnf -y upgrade && \
    # Install Development Tools group and additional dependencies
    dnf -y group install "Development Tools" && \
    dnf -y install \
    git elfutils-libelf-devel libasan libubsan make cmake3 gcc-c++ \
    clang-tools-extra openssl openssl-devel java-11-openjdk \
    python3 xz net-tools && \
    # Install glibc-langpack-en for locale
    dnf -y install glibc-langpack-en && \
    dnf clean all

# Install gtest
FROM baseimg as gtest
ARG GTEST_VER=v1.14.0
RUN set -x && \
    SRC=/usr/local/src/google-test-${GTEST_VER} && \
    mkdir -p $SRC && cd $SRC && \
    # Download and extract gtest source code
    curl -Lfs https://github.com/google/googletest/archive/refs/tags/${GTEST_VER}.tar.gz \
    | tar xz -C $SRC --strip-component=1 && \
    # Create build directory and compile gtest
    mkdir build && \
    cd build && cmake3 .. && \
    make -j8 && make install DESTDIR=/opt/gtest

# Build Final Image
FROM baseimg as buildimg

# Copy gtest binaries from the gtest stage
COPY --from=gtest /opt/gtest /

# Set Locale
RUN dnf -y install glibc-langpack-en

# Set environment variables for locale
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# Define the default command to run when the container starts
ENTRYPOINT ["/bin/bash", "-c"]