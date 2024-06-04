# Docker Containers Monitor

[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/ferdn4ndo/docker-containers-monitor/latest)](https://hub.docker.com/r/ferdn4ndo/docker-containers-monitor)
[![E2E test status](https://github.com/ferdn4ndo/docker-containers-monitor/actions/workflows/test_ut_e2e.yml/badge.svg?branch=main)](https://github.com/ferdn4ndo/docker-containers-monitor/actions)
[![GitLeaks test status](https://github.com/ferdn4ndo/docker-containers-monitor/actions/workflows/test_code_leaks.yml/badge.svg?branch=main)](https://github.com/ferdn4ndo/docker-containers-monitor/actions)
[![Grype test status](https://github.com/ferdn4ndo/docker-containers-monitor/actions/workflows/test_grype_scan.yml/badge.svg?branch=main)](https://github.com/ferdn4ndo/docker-containers-monitor/actions)
[![ShellCheck test status](https://github.com/ferdn4ndo/docker-containers-monitor/actions/workflows/test_code_quality.yml/badge.svg?branch=main)](https://github.com/ferdn4ndo/docker-containers-monitor/actions)
[![Release](https://img.shields.io/github/v/release/ferdn4ndo/docker-containers-monitor)](https://github.com/ferdn4ndo/docker-containers-monitor/releases)
![nginx 1.23.4](https://img.shields.io/badge/nginx-1.23.4-brightgreen.svg)
[![MIT license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)

A lightweight docker image for monitoring containers' resource usage and memory load in a web server with a simple UI. Includes a complete CI workflow with internal Unit Tests (UTs), and E2E Automated Tests (ATs). Protected against code leakage by [GitLeaks](https://github.com/gitleaks/gitleaks-action/) and package vulnerabilities by [Anchore Grype](https://github.com/anchore/grype). Code quality check by [ShellCheck](https://github.com/koalaman/shellcheck).

## Main features

* Lightweight (Alpine-based) docker image;
* Provides containers monitoring using `docker ps`;
* Provides disk usage statistics (from the host) using `df`;
* Provides memory usage statistics (from the host) using `cat /proc/meminfo`;
* Customizable refresh interval;
* Easy to expand for custom needs;
* Unit tests for the custom bash functions;
* Code leakage check on every push by [GitLeaks](https://github.com/gitleaks/gitleaks-action/);
* Third-packages vulnerabilities test on every push by [Anchore Grype](https://github.com/anchore/grype);
* Automatic code quality check on every push by [Shellcheck](https://github.com/koalaman/shellcheck);
* UT and E2E validation using [custom Github Actions](https://github.com/ferdn4ndo/docker-containers-monitor/blob/main/.github/workflows/test_ut_e2e.yml);

## Summary

* [Main Features](#main-features)
* [Summary](#summary) *(you're here)*
* [How to Run?](#how-to-run)
  * [Requirements](#requirements)
  * [Preparing the environment](#preparing-the-environment)
  * [Building the image](#building-the-image)
  * [Running in docker-compose](#running-in-docker-compose)
* [Configuring](#configuring)
  * [General Configuration](#general-configuration)
    * [VIRTUAL_HOST](#virtual_host)
    * [LETSENCRYPT_HOST](#letsencrypt_host)
    * [LETSENCRYPT_EMAIL](#letsencrypt_email)
    * [REFRESH_EVERY_SECONDS](#refresh_every_seconds)
    * [STATS_FILE](#stats_file)
* [Testing](#testing)
  * [Unit Tests (UTs)](#unit-tests-uts)
  * [End-to-End (E2E) Tests](#end-to-end-e2e-tests)
* [Contributing](#contributing)
  * [Contributors](#contributors)
* [License](#license)

## How to Run?

### Requirements

To run this service, make sure to comply with the following requirements:

1. Docker is installed and running in the host machine;

2. You have internet connection so docker can download what else is needed;

### Preparing the environment

First of all, clone the `.env.template` file to `.env` in the project root folder:

```bash
cp .env.template .env
```

Then edit the file accordingly. Check the [Configuring](#configuring) section for more information about the variables.

### Building the image

To build the image (assuming the `docker-containers-monitor` image name and the `latest` tag) use the following command in the project root folder:

```bash
docker build -f ./Dockerfile --tag docker-containers-monitor:latest
```

After setting up the environment and building the image, you can now launch a container with it. Considering the `.env` file prepare in the previous section, use the following command in the project root folder:

```bash
docker run --rm -v "./scripts:/scripts" -v "./html:/usr/share/nginx/html" -v "/var/run/docker.sock:/var/run/docker.sock:ro" --env-file ./.env -p "80:80" --name "docker-containers-monitor" docker-containers-monitor:latest
```

Note that the volumes `-v "./scripts:/scripts"` and `-v "./html:/usr/share/nginx/html"` are only needed when you want a hot-reload feature in the development environment (not needed in production), but the `-v "/var/run/docker.sock:/var/run/docker.sock:ro"` mount is always needed since the service must connect to the host' docker server in order to gather information about the other running containers.

### Running in docker-compose

As this repository has a Docker image available for pulling, we can add this service to an existing stack by creating a service using the `ferdn4ndo/docker-containers-monitor:latest` identifier:

```yaml
services:
  ...
  docker-containers-monitor:
    image: ferdn4ndo/docker-containers-monitor:latest
    container_name: docker-containers-monitor
    env_file:
      - ./.env
    ports:
      - "80:80" # Remove when running behind a reverse proxy
    volumes:
      - ./scripts:/scripts # Optional - for hot file swap only
      - ./html:/usr/share/nginx/html # Optional - for hot file swap only
      - ./default.conf:/etc/nginx/conf.d/default.conf # Optional - for hot file swap only
      - /var/run/docker.sock:/var/run/docker.sock:ro # Required to access information about other running containers
  ...
```

## Configuring

The service is configured using environment variables. They are listed and described below. Use the [Summary](#summary) for faster navigation.

### General Configuration

#### **VIRTUAL_HOST**

When running behind [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy), use this variable to set the domain to which the container will be exposed.

Required: **NO**

Default: *EMPTY*

#### **LETSENCRYPT_HOST**

When running behind [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) with SSL by [Let's Encrypt](https://github.com/nginx-proxy/acme-companion), use this variable to set the domain to which the certificate will be issued.

Required: **NO**

Default: *EMPTY*

#### **LETSENCRYPT_EMAIL**

When running behind [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) with SSL by [Let's Encrypt](https://github.com/nginx-proxy/acme-companion), use this variable to set the e-mail of the owner of the certificate that will be issued.

Required: **NO**

Default: *EMPTY*

#### **REFRESH_EVERY_SECONDS**

Determine the interval in seconds to call the heartbeat refresh script and update the stats.

Required: **NO**

Default: `5`

#### **STATS_FILE**

The path of the file that will be refreshed at every `REFRESH_EVERY_SECONDS` containing the instant stats.

Required: **NO**

Default: `/usr/share/nginx/html/stats.txt`

#### **FIFO_PATH**

The path of the FIFO pipe where the monitoring output will be sent. Defaults to a custom file path that will be created if not present.

Required: **NO**

Default: `/tmp/docker_containers_monitor`

## Custom logging command

Any command supplied to the docker image will be executed at every refresh interval and the output will be presented on the heartbeat file.

By default, the command `echo "Default command successfully executed"` is executed.

A custom command can also be specified at `docker-compose.yaml`:

```yaml
services:
  ...
  docker-containers-monitor:
    image: ferdn4ndo/docker-containers-monitor:latest
    container_name: docker-containers-monitor
    env_file:
      - ./.env
    command: echo "My custom command was executed" # <-- CUSTOM COMMAND HERE
    ports:
      - "80:80" # Remove when running behind a reverse proxy
    volumes:
      - ./scripts:/scripts # Optional - for hot file swap only
      - ./html:/usr/share/nginx/html # Optional - for hot file swap only
      - ./default.conf:/etc/nginx/conf.d/default.conf # Optional - for hot file swap only
      - /var/run/docker.sock:/var/run/docker.sock:ro # Required to access information about other running containers
  ...
```

## Testing

The repository pipelines also include testing for code leaks at [.github/workflows/test_code_leaks.yml](https://github.com/ferdn4ndo/docker-containers-monitor/blob/main/.github/workflows/test_code_leaks.yml), testing for package vulnerabilities at [.github/workflows/test_grype_scan.yml](https://github.com/ferdn4ndo/docker-containers-monitor/blob/main/.github/workflows/test_grype_scan.yml), testing for code quality at [.github/workflows/test_code_quality.yml](https://github.com/ferdn4ndo/docker-containers-monitor/blob/main/.github/workflows/test_code_quality.yml), and UTs (which will call the `run_*_tests.sh` scripts) + E2E functional tests at [.github/workflows/test_ut_e2e.yml](https://github.com/ferdn4ndo/docker-containers-monitor/blob/main/.github/workflows/test_ut_e2e.yml), which are described in the sections below.

### Unit Tests (UTs)

To execute the UTs, make sure that the `docker-containers-monitor` container is up and running.

This can be achieved by running the `docker-compose.yaml` file:

```bash
docker compose up --build --remove-orphans
```

Then, after the container is up and running, execute this command in the terminal to run the test script inside the `docker-containers-monitor` container:

```bash
# The UTs script must be executed from inside the service container
docker exec -it docker-containers-monitor sh -c "./run_unit_tests.sh"
```

The script will successfully execute if all the tests have passed or will abort with an error otherwise. The output is verbose, give a check.

### End-to-End (E2E) Tests

To execute the ATs (as in the UTs), please first make sure that the `docker-containers-monitor` container is up and running.

Then, **from the host terminal (not inside the container)**, execute the E2E test script:

```bash
# The E2E test script must be executed from the HOST machine (outside the service container)
./scripts/run_e2e_tests.sh
```

The script will successfully execute if all the tests have passed or will abort with an error otherwise. The output is verbose, give a check.

## Contributing

If you face a bug or would like to have a new feature, open an issue in this repository. Please describe your request as detailed as possible (remember to attach binary/big files externally), and wait for feedback. If you're familiar with software development, feel free to open a Pull Request with the suggested solution.

Any help is appreciated! Feel free to review, open an issue, fork, and/or open a PR. Contributions are welcomed!

### Contributors

[ferdn4ndo](https://github.com/ferdn4ndo)

## License

This application is distributed under the [MIT](https://github.com/ferdn4ndo/docker-containers-monitor/blob/main/LICENSE) license.
