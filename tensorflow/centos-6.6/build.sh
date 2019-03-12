#!/usr/bin/env bash
set -e

source /root/.bashrc

if [ "$USE_GPU" -eq "1" ]; then
  export CUDA_HOME="/usr/local/cuda"
  alias sudo=""
  source cuda.sh
  cuda.install $CUDA_VERSION $CUDNN_VERSION $NCCL_VERSION
  cd /
fi

# Enable GCC 6
chmod +x /build2.sh
scl enable devtoolset-6 ./build2.sh
