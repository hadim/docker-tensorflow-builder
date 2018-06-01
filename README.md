# Compile Tensorflow on Docker

Tensorflow devs only provide a limited set of build and TensorFlow can be challenging to compile yourself on certain configuration. With this `Dockerile`, you should be able to compile TensorFlow on any Linux platform that run Docker.

## Usage

- Edit the `build.sh` file as you wish.

- Build the Docker image for the compilation:

```bash
docker-compose build
```

- Launch the compilation:

```bash
docker-compose run tf
```

- Enjoy your Python wheels in the `wheels` folder.

## Authors

- Hadrien Mary <hadrien.mary@gmail.com>
