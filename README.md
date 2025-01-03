
# MotionEye with Motion 4.7 – Docker

This repository provides a Docker configuration to run **MotionEye** (bundled with Motion 4.7) inside a container. The Dockerfile is based on Debian Bookworm Slim, compiles Motion from source, and then installs MotionEye via `pip`.

## Contents

- **Dockerfile**  
  Contains all the steps necessary to build a Docker image featuring Motion 4.7 and MotionEye.  
- **entrypoint.sh**  
  A shell script that runs at container startup. It launches MotionEye in the foreground so that the Docker container keeps running.

## Requirements

- Docker installed (e.g., Docker Desktop, Docker Engine on Linux, etc.).
- Internet connectivity to download packages and source code.

## Usage

### 1. Clone the repository

```bash
git clone https://github.com/cefoot/motioneye_docker.git
cd motioneye_docker
```

### 2. Build the Docker image

```bash
docker build -t my-motioneye:latest .
```

This will build an image named `my-motioneye:latest`.

### 3. Run the container

```bash
docker run -d \
  --name motioneye_test \
  -p 8765:8765 \
  my-motioneye:latest
```

- `-d` launches the container in detached mode.  
- `-p 8765:8765` maps port 8765 inside the container to port 8765 on your host.  
- `--name motioneye_test` gives the container a friendly name.

### 4. Access the MotionEye web interface

Open your browser and go to:

```
http://localhost:8765
```

> If you’re running Docker on a remote server or VM, use the appropriate IP address or hostname instead of `localhost`.

By default, you should be able to log in with `admin` (no password). **Please set a password** immediately in the MotionEye UI.

## Data and Logs

By default, the container writes data to:
- `/var/lib/motioneye` (recordings, etc.)
- `/var/log/motioneye` (logs)
- `/etc/motioneye` (config files)

If you want your data to persist between container restarts, mount these directories as volumes:

```bash
docker run -d \
  -p 8765:8765 \
  -v /my/host/config:/etc/motioneye \
  -v /my/host/data:/var/lib/motioneye \
  my-motioneye:latest
```

## Customizing

- If you want a different Motion version (or a specific release of MotionEye), edit the **Dockerfile** accordingly.
- The **entrypoint.sh** script can be modified to add environment variables, logs, or any additional startup logic.

---

Enjoy running MotionEye with the latest Motion 4.7!
