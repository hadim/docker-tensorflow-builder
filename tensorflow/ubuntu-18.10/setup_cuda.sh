#!/usr/bin/env bash
set -e

cuda.install() {

  CUDA_PATH="/usr/local/cuda-$CUDA_VERSION"

  # Setup Cuda URL
  if [ "$CUDA_VERSION" = "9.0" ]; then
    CUDA_URL="https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run"
  elif [ "$CUDA_VERSION" = "9.1" ]; then
    CUDA_URL="https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux"
  elif [ "$CUDA_VERSION" = "9.2" ]; then
    CUDA_URL="https://developer.nvidia.com/compute/cuda/9.2/Prod/local_installers/cuda_9.2.88_396.26_linux"
  elif [ "$CUDA_VERSION" = "10.0" ]; then
    CUDA_URL="https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux"
  elif [ "$CUDA_VERSION" = "10.1" ]; then
    CUDA_URL="https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.105_418.39_linux.run"
  else
    echo "Error: You need to set CUDA_VERSION to 9.0, 9.1, 9.2, 10.0 or 10.1."
    return
  fi

  # Setup cuDNN URL
  if [ "$CUDNN_VERSION" = "7.0" ]; then

    # cuDNN 7.0
    if [ "$CUDA_VERSION" = "9.0" ]; then
      CUDNN_VERSION_DETAILED="7.0.5.15"
    elif [ "$CUDA_VERSION" = "9.1" ]; then
      CUDNN_VERSION_DETAILED="7.0.5.15"
    elif [ -n "$CUDNN_VERSION" ]; then
      echo "Error: cuDNN $CUDNN_VERSION is not compatible with Cuda $CUDA_VERSION."
      return
    fi

  # cuDNN 7.1
  elif [ "$CUDNN_VERSION" = "7.1" ]; then

    if [ "$CUDA_VERSION" = "9.0" ]; then
      CUDNN_VERSION_DETAILED="7.1.4.18"
    elif [ "$CUDA_VERSION" = "9.2" ]; then
      CUDNN_VERSION_DETAILED="7.1.4.18"
    elif [ -n "$CUDNN_VERSION" ]; then
      echo "Error: cuDNN $CUDNN_VERSION is not compatible with Cuda $CUDA_VERSION."
      return
    fi

  # cuDNN 7.4
  elif [ "$CUDNN_VERSION" = "7.4" ]; then

    if [ "$CUDA_VERSION" = "9.0" ]; then
      CUDNN_VERSION_DETAILED="7.4.2.24"
    elif [ "$CUDA_VERSION" = "9.2" ]; then
      CUDNN_VERSION_DETAILED="7.4.2.24"
    elif [ "$CUDA_VERSION" = "10.0" ]; then
      CUDNN_VERSION_DETAILED="7.4.2.24"
    elif [ -n "$CUDNN_VERSION" ]; then
      echo "Error: cuDNN $CUDNN_VERSION is not compatible with Cuda $CUDA_VERSION."
      return
    fi

  # cuDNN 7.5
  elif [ "$CUDNN_VERSION" = "7.5" ]; then

    if [ "$CUDA_VERSION" = "9.0" ]; then
      CUDNN_VERSION_DETAILED="7.5.0.56"
    elif [ "$CUDA_VERSION" = "9.2" ]; then
      CUDNN_VERSION_DETAILED="7.5.0.56"
    elif [ "$CUDA_VERSION" = "10.0" ]; then
      CUDNN_VERSION_DETAILED="7.5.0.56"
    elif [ "$CUDA_VERSION" = "10.1" ]; then
      CUDNN_VERSION_DETAILED="7.5.0.56"
    elif [ -n "$CUDNN_VERSION" ]; then
      echo "Error: cuDNN $CUDNN_VERSION is not compatible with Cuda $CUDA_VERSION."
      return
    fi

  elif [ -n "$CUDNN_VERSION" ]; then
    echo "Error: You need to set CUDNN_VERSION to 7.0, 7.1, 7.4 or 7.5."
    return
  fi

  CUDNN_URL="https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7_${CUDNN_VERSION_DETAILED}-1+cuda${CUDA_VERSION}_amd64.deb"
  CUDNN_URL_DEV="https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7-dev_${CUDNN_VERSION_DETAILED}-1+cuda${CUDA_VERSION}_amd64.deb"

  echo "* Installing Cuda $CUDA_VERSION."

  # Install Cuda
  wget "$CUDA_URL" -O "/tmp/cuda.run"
  bash "/tmp/cuda.run" --silent --toolkit --override --toolkitpath="$CUDA_PATH"
  rm -f "/tmp/cuda.run"
  rm -f "$(dirname $CUDA_PATH)/cuda"
  ln -s $CUDA_PATH "$(dirname $CUDA_PATH)/cuda"

  echo "* Cuda $CUDA_VERSION is installed at $CUDA_PATH."

  if [ -z "$CUDNN_VERSION" ]; then
    return
  fi

  echo "* Installing cuDNN $CUDNN_VERSION."

  # Install cuDNN .so files
  wget "$CUDNN_URL" -O "/tmp/cudnn.deb"
  mkdir -p /tmp/cudnn
  cd /tmp/cudnn
  ar x ../cudnn.deb
  tar -xJf data.tar.xz
  mv usr/lib/x86_64-linux-gnu/libcudnn* $CUDA_PATH/lib64/
  rm -fr /tmp/cudnn
  rm -f /tmp/cudnn.deb
  cd ../

  # Install cuDNN .h and static lib files
  wget "$CUDNN_URL_DEV" -O "/tmp/cudnn-dev.deb"
  mkdir -p /tmp/cudnn-dev
  cd /tmp/cudnn-dev
  ar x ../cudnn-dev.deb
  tar -xJf data.tar.xz
  mv usr/include/x86_64-linux-gnu/cudnn_v7.h $CUDA_PATH/include/
  ln -s $CUDA_PATH/include/cudnn_v7.h $CUDA_PATH/include/cudnn.h
  mv usr/lib/x86_64-linux-gnu/libcudnn_static_v7.a $CUDA_PATH/lib64/
  ln -s $CUDA_PATH/lib64/libcudnn_static_v7.a $CUDA_PATH/lib64/libcudnn_static.a
  rm -fr /tmp/cudnn-dev
  rm -f /tmp/cudnn-dev.deb
  cd ../

  echo "* cuDNN $CUDNN_VERSION is installed at $CUDA_PATH."
}

cuda.install()
