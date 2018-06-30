#!/usr/bin/env bash
set -e

bash setup_cuda.sh

# Enable GCC 6
chmod +x /build2.sh
scl enable devtoolset-4 ./build2.sh
