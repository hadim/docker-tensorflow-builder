#!/usr/bin/env bash
set -e

source /root/.bashrc

if [ "$USE_GPU" -eq "1" ]; then
	bash setup_cuda.sh
fi

# Enable GCC 5
chmod +x /build2.sh
scl enable devtoolset-4 ./build2.sh
