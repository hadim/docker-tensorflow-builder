#!/usr/bin/env bash
set -x

if [ "$TF_COMPILATION_WITH_GPU" == "1" ] ; then

	echo "Compile TensorFlow with Cuda enabled."

	cd /binaries

    # Install Cuda 9.2
	if [ ! -f "cuda.run" ]; then
		wget https://developer.nvidia.com/compute/cuda/9.2/Prod/local_installers/cuda_9.2.88_396.26_linux -O cuda.run
	fi
	bash cuda.run --silent --toolkit --override
	rm cuda.run

	# Install cuDNN 7.1
	tar --no-same-owner -xzf cudnn*.tgz -C /usr/local --wildcards 'cuda/lib64/libcudnn.so.*'
	tar --no-same-owner -xzf cudnn*.tgz -C /usr/local --wildcards 'cuda/include/*.h'

	# Cuda parameters for the build
	export CUDA_TOOLKIT_PATH=/usr/local/cuda
	export CUDNN_INSTALL_PATH=/usr/local/cuda
	export TF_CUDA_VERSION="$($CUDA_TOOLKIT_PATH/bin/nvcc --version | sed -n 's/^.*release \(.*\),.*/\1/p')"
	export TF_CUDNN_VERSION="$(sed -n 's/^#define CUDNN_MAJOR\s*\(.*\).*/\1/p' $CUDNN_INSTALL_PATH/include/cudnn.h)"
	export TF_NEED_CUDA=1
	export TF_NEED_TENSORRT=0
	export TF_NCCL_VERSION=1.3

	BAZEL_BUILD_OPTIONS="--config=cuda"
else
	echo "Compile TensorFlow with Cuda disabled."

	export TF_NEED_CUDA=0
	BAZEL_BUILD_OPTIONS=""
fi

# Compile TensorFlow

# Here you can change the TensorFlow version you want to build.
# You can also tweak the optimizations and various parameters for the build compilation.
# See https://www.tensorflow.org/install/install_sources for more details.

cd /
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

# Compilation
./configure

bazel build --config=opt \
		    $BAZEL_BUILD_OPTIONS \
		    --action_env="LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" \
		    //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package /wheels

# Fix wheel folder permissions
chmod 777 /wheels/*