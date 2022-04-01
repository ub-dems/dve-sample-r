#!/bin/bash

## build ARGs
NCPUS=${NCPUS:--1}

set -e
apt-get update -qq && apt-get -y --no-install-recommends install \
    vim \
    zsh \
    mc \
    ranger \
    silversearcher-ag \
    hwloc && \
    tasksel && \
    numactl && \
    inxi && \
    htop && \
  rm -rf /var/lib/apt/lists/*

## R benchmarks
install2.r --error --skipmissing --skipinstalled -n $NCPUS \
    cli \
    ps \
    benchmarkme \
    benchmarkmeData \
    rbenchmark \
    microbenchmark

## a bridge to far? -- brings in another 60 packages
# install2.r --error --skipinstalled -n $NCPUS tidymodels

 rm -rf /tmp/downloaded_packages
