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

- Choose which flavor you wan to compile:

```bash
cd tensorflow-gpu/
# or
cd tensorflow/
```

- If compiling `tensorflow-gpu`, download [cuDNN](https://developer.nvidia.com/cudnn) and put it in a folder called `binaries/`. *(Yes, it's not possible to download cuDNN within a script and you need to login to the NVIDIA website to do it. And yes it's extreeemly boring!)*

- If compiling `tensorflow-gpu`, you need to set [your default Docker runtime to `nvidia-docker`](https://github.com/NVIDIA/nvidia-docker).

- Edit `docker-compose.yml`. Set the `TF_VERSION_GIT_TAG` variable.

- Edit the `build.sh` file as you wish. Here you can modify TensorFlow compilation options.

- Build the Docker image for the compilation:

```bash
docker-compose build
```

- Launch the bash console and start the compilation:

```bash
docker-compose run tf
bash build.sh
```

- Be patient, the compilation can be long.

- Enjoy your Python wheels in the `wheels/` folder.

## Authors

- Hadrien Mary <hadrien.mary@gmail.com>

## License

MIT License. See [LICENSE](LICENSE).