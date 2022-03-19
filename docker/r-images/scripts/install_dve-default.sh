#!/bin/bash

## build ARGs
NCPUS=${NCPUS:--1}

set -e
apt-get update -qq && apt-get -y --no-install-recommends install \
    libreadline-dev \
    libssl-dev && \
  rm -rf /var/lib/apt/lists/*

## R dependencies
install2.r --error --skipmissing --skipinstalled -n $NCPUS \
    cvt \
    utils


 rm -rf /tmp/downloaded_packages
