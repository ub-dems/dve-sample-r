#!/bin/bash

## build ARGs
NCPUS=${NCPUS:--1}

set -e
apt-get update -qq && apt-get -y --no-install-recommends install \
    less \
    ssh \
    vim \
    zsh \
    mc \
    ranger \
    silversearcher-ag \
    parallel \
    hwloc \
    tasksel \
    numactl \
    inxi \
    htop && \
  rm -rf /var/lib/apt/lists/*

## R benchmarks
install2.r --error --skipmissing --skipinstalled -n $NCPUS \
    remotes \
    renv \
    devtools \
    cli \
    logging \
    logger \
    pak \
    ps \
    sysreqs \
    benchmarkme \
    benchmarkmeData \
    rbenchmark \
    microbenchmark \
    ragg \
    reprex \
    styler

## a bridge to far? -- brings in another 60 packages
# install2.r --error --skipinstalled -n $NCPUS tidymodels

 rm -rf /tmp/downloaded_packages
