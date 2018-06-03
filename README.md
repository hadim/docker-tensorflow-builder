# Compile Tensorflow on Docker

Docker images to compile TensorFlow yourself.

Tensorflow only provide a limited set of build and it can be challenging to compile yourself on certain configuration. With this `Dockerile`, you should be able to compile TensorFlow on any Linux platform that run Docker.

## Requirements

- `docker`.
- `docker-compose`.
- `nvidia-docker` if compiling with CUDA support

## Usage

- Clone this repository:

```bash
git clone https://github.com/hadim/docker-tensorflow-builder.git
```

### TensoFlow CPU

- Edit the `build.sh` file as you wish. Here you can modify TensorFlow compilation options.

```bash
cd tensorflow/

# Build the Docker image
docker-compose build

# Set env variables
export TF_VERSION_GIT_TAG=v1.8.0

# Launch the Docker console
docker-compose run tf

# Start the compilation (this command is executed inside the Docker container)
bash build.sh
```

### TensorFlow GPU

- Download [cuDNN](https://developer.nvidia.com/cudnn) and put it in a folder called `cudnn/`. *(Yes, it's not possible to download cuDNN within a script and you need to login to the NVIDIA website to do it. And yes it's extreeemly boring!)*.

- Set [your default Docker runtime to `nvidia-docker`](https://github.com/NVIDIA/nvidia-docker).

- Edit the `build.sh` file as you wish. Here you can modify TensorFlow compilation options.

```bash
cd tensorflow-gpu/

# Build the Docker image
docker-compose build

# Set env variables
export TF_VERSION_GIT_TAG=v1.8.0
export CUDA_VERSION=9.1
export CUDNN_VERSION=7.1

# Launch the Docker console
docker-compose run tf

# Start the compilation (this command is executed inside the Docker container)
bash build.sh
```

---

- Be patient, the compilation can be long.
- Enjoy your Python wheels in the `wheels/` folder.
- *Don't forget to remove the container to free the space after the build: `docker-compose rm --force`.*

## Builds

| TF | Python | Processor | Platform | GC | Flags | CUDA | cuDNN | Worked? | Link |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1.8.0 | 3.6 | Intel Core i7-7700HQ | CPU | - | `avx sse` | - | - | **Yes** | [Link](https://storage.googleapis.com/tensorflow-builds/boromir/cpu/tensorflow-1.8.0-cp36-cp36m-linux_x86_64.whl) |
| 1.8.0 | 3.6 | Intel Core i7-7700HQ | GPU | GeForce GTX 1050 Ti Mobile | `avx sse` | 9.0 | 7 | **Yes** |
| 1.8.0 | 3.6 | Intel Core i7-7700HQ | GPU | GeForce GTX 1050 Ti Mobile | `avx sse` | 9.0 | 7.1 | **Yes** |
| 1.8.0 | 3.6 | Intel Core i7-7700HQ | GPU | GeForce GTX 1050 Ti Mobile | `avx sse` | 9.1 | 7.1 | **Yes** | [Link](https://storage.googleapis.com/tensorflow-builds/boromir/gpu-cuda-9.1-cudnn-7.1/tensorflow-1.8.0-cp36-cp36m-linux_x86_64.whl) |
| 1.8.0 | 3.6 | Intel Core i7-7700HQ | GPU | GeForce GTX 1050 Ti Mobile | `avx sse` | 9.2 | 7.1 | **No** |
| 1.8.0 | 3.6 | Intel Core i7 960 | CPU | - | `sse` | - | - | **Soon** |
| 1.8.0 | 3.6 | Intel Core i7 960 | GPU | GeForce GTX 1050 Ti | `sse` | 9.0 | 7 | **Soon** |
| 1.8.0 | 3.6 | Intel Core i7 960 | GPU | GeForce GTX 1050 Ti | `sse` | 9.0 | 7.1 | **Soon** |
| 1.8.0 | 3.6 | Intel Core i7 960 | GPU | GeForce GTX 1050 Ti | `sse` | 9.1 | 7.1 | **Soon** |
| 1.8.0 | 3.6 | Intel Core i7 960 | GPU | GeForce GTX 1050 Ti | `sse` | 9.2 | 7.1 | **Soon** |

## Authors

- Hadrien Mary <hadrien.mary@gmail.com>

## License

MIT License. See [LICENSE](LICENSE).