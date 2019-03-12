FROM centos:7.4.1708

RUN yum update -y && \
    yum install -y \
    curl \
    git \
    wget \
    tar \
    bzip2 \
    patch \
    gcc \
    gcc-c++ \
    which && \
    yum -y install centos-release-scl && \
    yum -y install devtoolset-4-gcc devtoolset-4-gcc-c++ && \
    yum clean all

# Install Anaconda
WORKDIR /
RUN wget "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O  "miniconda.sh" && \
    bash "miniconda.sh" -b -p "/conda" && \
    rm -f miniconda.sh && \
    echo PATH='/conda/bin:$PATH' >> /root/.bashrc && \
    /conda/bin/conda config --add channels conda-forge && \
    /conda/bin/conda update --yes -n base conda && \
    /conda/bin/conda update --all --yes

COPY build.sh /build.sh
COPY build2.sh /build2.sh
COPY cuda.sh /cuda.sh

CMD bash build.sh
