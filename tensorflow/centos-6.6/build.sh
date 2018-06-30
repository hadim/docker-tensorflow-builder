#!/usr/bin/env bash
set -e

if [ "$USE_GPU" -eq "1" ]; then
   bash setup_cuda.sh
fi

# Enable GCC 6
chmod +x /build2.sh
scl enable devtoolset-6 ./build2.sh
