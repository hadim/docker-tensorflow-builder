#!/usr/bin/env bash
set -e

if [ "$USE_GPU" -eq "1" ]; then
   bash setup_cuda.sh
fi

./build2.sh