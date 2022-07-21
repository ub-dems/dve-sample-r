---
title: Jenkis Pipelines
subtitle: Jenkis+Podman builds
caption: jenkins pipes
author: --
date: 2022-05-17
---
|   |   |                                     |                               |                                   |
|---|---|-------------------------------------|-------------------------------|-----------------------------------|
|   |   | [Up: CI/CD Pipelines](../README.md) | [[Contents]](../../README.md) | [[Index]](../../_index/README.md) |

_**WARNING:**_ *this module isn't released yet ...*

JENKINS PIPELINES
=================

Status
------

_Project Batch execution/tracking and build/deploy procedures (CI/CD pipelines) are still in "work in progress" status_

_This draft document collects online refences and unreleased commands_


References
----------

* [How to build images with rootless Podman in Jenkins on OpenShift](https://www.redhat.com/sysadmin/rootless-podman-jenkins-openshift)
* [How to run a Jenkins container using podman ?](https://access.redhat.com/solutions/6095171)
* [jenkins installation using Podman](https://youtu.be/qGLEuXK46gQ)
* []()
* []()
* []()
* []()
* []()






JENKINS SETUP (PODMAN)
======================


Jenkins (privileged) Installation
---------------------------------


### 1. volume

Create the following volumes to persist the Jenkins data using the following docker volume create commands:

```bash

# (RunAs: root)

podman volume create jenkins-data

```


### 2. run jenkins under podman

Download the jenkinsci/blueocean image and run it as a container in podman using the following podman container run command

```bash

podman container run \
        --name jenkins-blueocean \
        --rm \
        --detach \
        --privileged \
        --publish 8080:8080 \
        --publish 50000:50000 \
        --volume jenkins-data:/var/jenkins_home \
        --volume jenkins-docker-certs:/certs/client:ro \
        docker.io/jenkinsci/blueocean

```



### 3. status

Check the Jenkins container is up and running

```bash

podman ps

```




### 4. credentials

Copy the automatically-generated alphanumeric password from the Jenkins container location /var/jenkins_home/secrets/initialAdminPassword



```bash

podman exec -it jenkins-app sh

    ~ $ cat /var/jenkins_home/secrets/initialAdminPassword

    a72e26e162344d69b60da77d5e56a4aa

```


### 5. connect


Browse to http://localhost:8080 and wait until the Unlock Jenkins page appears.



