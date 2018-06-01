FROM ubuntu:18.04

RUN apt update && apt install -y \
    build-essential \
    curl \
    git \
    wget \
    libjpeg-dev \
    openjdk-8-jdk \
    && rm -rf /var/lib/lists/*

# Install GCC 6 and make it the default compiler
RUN apt install gcc-6 g++-6 -y && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6

COPY bazel.list /etc/apt/sources.list.d/
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && apt-get install -y bazel

# Install Anaconda
WORKDIR /
RUN wget "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O "miniconda.sh" && \
    bash "miniconda.sh" -b -p "/conda" && \
    rm miniconda.sh && \
    echo PATH='/conda/bin:$PATH' >> /root/.bashrc && \
    /conda/bin/conda config --add channels conda-forge && \
    /conda/bin/conda update --yes -n base conda && \
    /conda/bin/conda update --all --yes && \
    /conda/bin/conda install --yes numpy wheel

COPY build.sh /build.sh

ENTRYPOINT /build.sh