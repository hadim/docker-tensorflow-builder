FROM tensorflow/tensorflow:latest-gpu

RUN apt update && apt install -y \
    build-essential \
    curl \
    git \
    wget \
    openjdk-8-jdk \
    && rm -rf /var/lib/lists/*

COPY bazel.list /etc/apt/sources.list.d/
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && apt-get install -y bazel

# Install Anaconda
WORKDIR /
RUN wget "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O "miniconda.sh"
RUN bash "miniconda.sh" -b -p "/conda"
RUN echo PATH='/conda/bin:$PATH' >> /root/.bashrc
RUN /conda/bin/conda config --add channels conda-forge && \
    /conda/bin/conda update --yes -n base conda && \
    /conda/bin/conda update --all --yes && \
    /conda/bin/conda install --yes jupyterlab nb_conda_kernels node numpy wheel

# Remove previous Cuda version
RUN rm -fr /usr/local/cuda*

# Install Cuda from the .deb (in order to provide include files)
RUN wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-ubuntu1704-9-0-local_9.0.176-1_amd64-deb
RUN dpkg -i dpkg -i cuda-repo-ubuntu1704-9-0-local_9.0.176-1_amd64.deb
RUN apt update
RUN apt install cuda

# Remove old cuDNN library
run rm -f /usr/lib/x86_64-linux-gnu/libcudnn*

# Install cuDNN
# cuDNN license: https://developer.nvidia.com/cudnn/license_agreement
ENV CUDDN_URL http://developer.download.nvidia.com/compute/redist/cudnn/v7.1.4/cudnn-9.0-linux-x64-v7.1.tgz
RUN wget $CUDDN_URL
RUN tar --no-same-owner -xzf cudnn-9.0-linux-x64-v7.1.tgz -C /usr/local --wildcards 'cuda/lib64/libcudnn.so.*'
RUN tar --no-same-owner -xzf cudnn-9.0-linux-x64-v7.1.tgz -C /usr/local --wildcards 'cuda/include/*.h'

COPY build.sh /build.sh

ENTRYPOINT /build.sh