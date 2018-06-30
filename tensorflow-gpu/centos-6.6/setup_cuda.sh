#!/usr/bin/env bash

# Remove previous Cuda and cuDNN installation
rm -fr /usr/local/cuda*
find /usr -name *cudnn* -exec rm {} +

# Test if an NVIDIA card is detected
if (( $(find /dev -name nvidia* |wc -l) == 0 )); then
	echo "Error: It looks like there is no NVIDIA cards detected in /dev."
	echo "Did you use nvidia-docker as a Docker runtime?"
	exit -1
fi

# Install Cuda
if [ "$CUDA_VERSION" = "9.0" ]; then
	CUDA_URL="https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run"
elif [ "$CUDA_VERSION" = "9.1" ]; then
	CUDA_URL="https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux"
elif [ "$CUDA_VERSION" = "9.2" ]; then
	CUDA_URL="https://developer.nvidia.com/compute/cuda/9.2/Prod/local_installers/cuda_9.2.88_396.26_linux"
else
	echo "Error: You need to set CUDA_VERSION to 9.0, 9.1 or 9.2."
	exit -1
fi
wget $CUDA_URL -O "/tmp/cuda.run"
bash "/tmp/cuda.run" --silent --toolkit --override
rm -f "/tmp/cuda.run"

# Install cuDNN
cd /cudnn
CUDNN_FILENAME="cudnn-$CUDA_VERSION-linux-x64-v$CUDNN_VERSION.tgz"
if [ ! -f $CUDNN_FILENAME ]; then
    echo "Error: cuDNN archive $CUDNN_FILENAME does not exist. Please copy it into the cudnn/ folder."
    exit -1
fi
tar --no-same-owner -xzf $CUDNN_FILENAME -C /usr/local --wildcards 'cuda/*'