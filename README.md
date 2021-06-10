# Docker Dynamic DNS to use Google Domains, DuckDNS, DynDNS, FreeDNS.afraid and NO-IP

Dynamic DNS services have been around since the early days of the internet. Generally speaking, internet service providers (ISP's) will reassign an IP address to a subscriber after some period of time or if the user reconnects his or her connection.

This is a fork of [blaize/docker-dynamic-dns](https://hub.docker.com/r/blaize/docker-dynamic-dns/)

The environmental variables are as follows:
* `TZ`: name of the TimeZone - ie. "Etc/UTC" or "Europe/Paris" (https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
* `USER`: the username for the service.
* `PASSWORD`: the password or token for the service.
* `SERVICE`: The service you are using. Currently, the script is setup to use Google Domains (google), DuckDNS (duckdns), DynDNS (dyndns), FreeDNS.afraid.org (freedns) and NO-IP (noip). Set the service to the value in parenthesis.
* `HOSTNAME`: The host name that you are updating. ie. example.com
* `DETECTIP`: If this is set to 1, then the script will detect the external IP of the service on which the container is running, such as the external IP of your DSL or cable modem.
* `IP`: if DETECTIP is not set, you can specify an IP address.
* `UPDATEIPV6`: If this is set to 1, then the script will detect the external IPv6 address of the service on which the container is running.
* `INTERVAL`: How often the script should call the update services in minutes.

## Installation via Docker

Please follow the official documentation:

    https://docs.docker.com/install/

### Docker image platform / architecture

The Docker image to use `joweisberg/dynamic-dns:latest`.
Build on Linux Ubuntu 20.04 LTS, Docker 19.03 for:
- `x86_64` / `amd64`
- `aarch64` / `arm64v8`
- `arm` / `arm32v6`

### Docker

Get the container:
```bash
$ docker pull joweisberg/dynamic-dns:latest
```

Run the container in *console mode* (notice the environment variable setting parameters for the startup command):
```bash
$ docker run -d --restart=unless-stopped -e TZ=Europe/Paris -e USER=username -e PASSWORD=password -e SERVICE=freedns -e HOSTNAME=sub.example.com -e DETECTIP=1 -e INTERVAL=10 joweisberg/dynamic-dns:latest
```

### Docker Compose

```yml
version: "3.5"
services:
  dynamic-dns:
    container_name: dynamic-dns
    image: joweisberg/dynamic-dns:latest
    restart: unless-stopped
    environment:
      - TZ=Europe/Paris
      - USER=username
      - PASSWORD=password
      - SERVICE=freedns
      - HOSTNAME=sub.example.com
      - DETECTIP=1
      - INTERVAL=10
    healthcheck:
      test: ["CMD", "/usr/bin/healthcheck"]
      interval: 30s
      timeout: 10s
      retries: 5
```
