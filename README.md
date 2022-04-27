# CheckMK Scripts for the SLATE API server

This repository contains the scripts necessary for the correct monitoring of the API server.

## Descriptions

Pending.

## Local Development with Docker Compose

> **_IMPORTANT:_** this section requires familiarity with [Running the Server](https://github.com/slateci/slate-client-server/blob/master/resources/docs/server_running.md).

This local process is meant to mimic our Kubernetes cluster out on the Google Kubernetes Engine (GKE). There each script is instantiated as a <something> template.

This template has the following available to it:
* A copy of `resources/docker/conf/slate.conf` mounted to `${SLATE_API_CONF}`.
* The Docker environmental variables defined in `.env.tmpl` as full system-level environmental variables.

### Requirements

#### Install Docker/Compose

Install [Docker](https://docs.docker.com/get-docker/) and [docker-compose](https://docs.docker.com/compose/install/) for developing, managing, and running OCI containers on your system.

#### Create `.env`

1. Copy `.env.tmpl` to the following place in this project: `.env`.
2. Modify the included environmental variables as desired.

### Build and Run API Scripts Environment

Bring up the local development environment via the following:

```shell
[your@localmachine]$ docker-compose up
Building slate_checkmk_scripts
Sending build context to Docker daemon  22.02kB
Step 1/11 : ARG baseimage=centos:7
Step 2/11 : FROM ${baseimage} as local-stage
 ---> eeb6ee3f44bd
Step 3/11 : RUN yum install epel-release -y
...
...
Successfully tagged slate_checkmk_scripts:local
Recreating slate_checkmk_scripts ... done
Attaching to slate_checkmk_scripts
slate_checkmk_scripts    | Copying clean slate.conf...
```

### Test the CheckMK Scripts

While `docker-compose` is still running attach to the `slate_checkmk_scripts` container and run a script(s) in `/slate/scripts`:

```shell
$ docker exec -it slate_checkmk_scripts bash
[root@d614a7bf3483 slate]# cd /slate/scripts
[root@d614a7bf3483 scripts]# ./test.sh
...
...
```

### Teardown

In the terminal session running `docker-compose up` type `CTRL + C` to stop all existing containers. Finally, teardown using one of the following options:

* Leave the associated images, volumes, and networks on your machine by executing:

  ```shell
  [your@localmachine]$ docker-compose down
  ```

  **Result:** re-running `docker-compose up` will restart services with their existing states.

* Completely remove everything:

  ```shell
  [your@localmachine]$ docker-compose down --rmi all
  ```

  **Result:** re-running `docker-compose up` will start everything from scratch.
