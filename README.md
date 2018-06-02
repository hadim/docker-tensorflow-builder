# Compile Tensorflow on Docker

Docker images to compile TensorFlow yourself.

Tensorflow only provide a limited set of build and it can be challenging to compile yourself on certain configuration. With this `Dockerile`, you should be able to compile TensorFlow on any Linux platform that run Docker.

## Usage

- Download cuDNN and put it in a folder called `cudnn`.

- Select a directory with or without GPU support:

```bash
cd tensorflow-gpu/
```

- Edit the `build.sh` file as you wish.
- You can edit the `Dockerfile` to change Cuda and cuDNN version.

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

- Enjoy your Python wheels in the `wheels` folder.

## Authors

- Hadrien Mary <hadrien.mary@gmail.com>

## License

MIT License. See [LICENSE](LICENSE).