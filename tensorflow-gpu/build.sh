#!/usr/bin/env bash
set -e

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

# Install cuDNN
cd /cudnn
CUDNN_FILENAME="cudnn-$CUDA_VERSION-linux-x64-v$CUDNN_VERSION.tgz"
if [ ! -f $CUDNN_FILENAME ]; then
    echo "Error: cuDNN archive $CUDNN_FILENAME does not exist. Please copy it into the cudnn/ folder."
    exit -1
fi
tar --no-same-owner -xzf $CUDNN_FILENAME -C /usr/local --wildcards 'cuda/*'

# Compile TensorFlow

# Here you can change the TensorFlow version you want to build.
# You can also tweak the optimizations and various parameters for the build compilation.
# See https://www.tensorflow.org/install/install_sources for more details.

cd /
rm -fr tensorflow/
git clone --depth 1 --branch $TF_VERSION_GIT_TAG "https://github.com/tensorflow/tensorflow.git"

TF_ROOT=/tensorflow
cd $TF_ROOT

# Python path options
export PYTHON_BIN_PATH="/conda/bin/python"
export PYTHON_LIB_PATH="$($PYTHON_BIN_PATH -c 'import site; print(site.getsitepackages()[0])')"
export PYTHONPATH=${TF_ROOT}/lib
export PYTHON_ARG=${TF_ROOT}/lib

# All other parameters
export TF_NEED_GCP=1
export TF_CUDA_COMPUTE_CAPABILITIES=5.2,3.5
export TF_NEED_HDFS=1
export TF_NEED_OPENCL=0
export TF_NEED_JEMALLOC=1
export TF_ENABLE_XLA=0
export TF_NEED_VERBS=0
export TF_CUDA_CLANG=0
export TF_DOWNLOAD_CLANG=0
export TF_NEED_MKL=0
export TF_DOWNLOAD_MKL=0
export TF_NEED_MPI=0
export TF_NEED_S3=1
export TF_NEED_KAFKA=1
export TF_NEED_GDR=0
export TF_NEED_OPENCL_SYCL=0
export TF_SET_ANDROID_WORKSPACE=0

# Compiler options
export GCC_HOST_COMPILER_PATH=$(which gcc)
export CC_OPT_FLAGS="-march=native"

# Cuda parameters
export CUDA_TOOLKIT_PATH=/usr/local/cuda
export CUDNN_INSTALL_PATH=/usr/local/cuda
export TF_CUDA_VERSION="$CUDA_VERSION"
export TF_CUDNN_VERSION="$(sed -n 's/^#define CUDNN_MAJOR\s*\(.*\).*/\1/p' $CUDNN_INSTALL_PATH/include/cudnn.h)"
export TF_NEED_CUDA=1
export TF_NEED_TENSORRT=0
export TF_NCCL_VERSION=1.3

# Those two lines are important for the linking step.
export LD_LIBRARY_PATH="$CUDA_TOOLKIT_PATH/lib64:${LD_LIBRARY_PATH}"
ldconfig

# Compilation
./configure

bazel build --config=opt \
		    --config=cuda \
		    --action_env="LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" \
		    //tensorflow/tools/pip_package:build_pip_package

# Project name can only be set for TF > 1.8
#PROJECT_NAME="tensorflow_gpu_cuda_${TF_CUDA_VERSION}_cudnn_${TF_CUDNN_VERSION}"
#bazel-bin/tensorflow/tools/pip_package/build_pip_package /wheels --project_name $PROJECT_NAME

bazel-bin/tensorflow/tools/pip_package/build_pip_package /wheels

# Fix wheel folder permissions
chmod -R 777 /wheels/