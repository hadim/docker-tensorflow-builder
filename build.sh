#!/usr/bin/env bash


TENSORFLOW_VERSION_TAG="v1.7.1"
git clone --depth 1 --branch $TENSORFLOW_VERSION_TAG "https://github.com/tensorflow/tensorflow.git"

cd /tensorflow

#./configure
#bazel build --config=opt --config=mkl //tensorflow/tools/pip_package:build_pip_package
