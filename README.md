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

## Authors

- Hadrien Mary <hadrien.mary@gmail.com>

## License

MIT License. See [LICENSE](LICENSE).