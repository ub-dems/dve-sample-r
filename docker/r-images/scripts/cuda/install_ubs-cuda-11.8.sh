#!/bin/bash

## Update base nvidia/cuda image:
##     "nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04"
## 
## Install nvidia extras
##    @see: https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_cuda-11.1.sh
##

## build ARGs
set -e
source ${Y_BUILD_CONF:-/etc/build.conf}

NCPUS=${NCPUS:--1}


function env_dump() {
    
    [ "$Y_DEBUG_ENV" = 1 ] || return 0
    
    echo "+++> #ENV($0): $@"
    echo "+++: #ENV($0): set"
    set | grep '^Y_' | sort
    echo "+++: #ENV($0): env"
    env | sort
    echo "+++: #ENV($0): path"
    echo "PATH=$PATH"
    echo "+++< #ENV($0): $@"
    
}

function setenv_rehash() {
    env_dump "setenv_rehash::pre"
    source /etc/profile
    #export PS1='# '; source /etc/bash.bashrc
    env_dump "setenv_rehash::post"
}


# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

function install_compiler() {

    [ "$Y_NV_CUDA_COMPILER" = 1 ] || return 0

    apt_install \
        cuda-compiler-11-1 \
        cuda-nvcc-11-1
    

}

function install_tools() {

    [ "$Y_NV_CUDA_TOOLS" = 1 ] || return 0

    apt_install \
        cuda-memcheck-11-1 
    
    #       cuda-command-line-tools-11-1 \ =>

# The following additional packages will be installed:
#   build-essential cuda-cuobjdump-11-1 cuda-cupti-11-1 cuda-cupti-dev-11-1
#   cuda-gdb-11-1 cuda-nvcc-11-1 cuda-nvdisasm-11-1 cuda-sanitizer-11-1 dpkg-dev
#   patch
# Suggested packages:
#   debian-keyring ed diffutils-doc
# Recommended packages:
#   fakeroot libalgorithm-merge-perl
# The following NEW packages will be installed:
#   build-essential cuda-command-line-tools-11-1 cuda-cuobjdump-11-1
#   cuda-cupti-11-1 cuda-cupti-dev-11-1 cuda-gdb-11-1 cuda-memcheck-11-1
#   cuda-nvcc-11-1 cuda-nvdisasm-11-1 cuda-sanitizer-11-1 dpkg-dev patch    

}

function install_libraries() {

    [ "$Y_NV_CUDA_LIBRARIES" = 1 ] || return 0

##FROM ${IMAGE_NAME}:11.1-base-ubuntu20.04

# NCCL_VERSION=${NCCL_VERSION:-2.7.8}

# apt_install \
#     cuda-libraries-11-1=11.1.1-1 \
#     libnpp-11-1=11.1.2.301-1 \
#     cuda-nvtx-11-1=11.1.74-1 \
#     libcublas-11-1=11.3.0.106-1 \
#     "libnccl2=$NCCL_VERSION-1+cuda11.1"

# apt-mark hold libnccl2

# ## devel #######################################################

# apt_install \
#     cuda-nvml-dev-11-1=11.1.74-1 \
#     cuda-command-line-tools-11-1=11.1.1-1 \
#     cuda-nvprof-11-1=11.1.105-1 \
#     libnpp-dev-11-1=11.1.2.301-1 \
#     cuda-libraries-dev-11-1=11.1.1-1 \
#     cuda-minimal-build-11-1=11.1.1-1 \
#     libnccl-dev=2.7.8-1+cuda11.1 \
#     libcublas-dev-11-1=11.3.0.106-1 \
#     libcusparse-11-1=11.3.0.10-1 \
#     libcusparse-dev-11-1=11.3.0.10-1
# apt-mark hold libnccl-dev

    # apt_install \
    #     cuda-nvrtc-11-1 \
    #     cuda-nvrtc-dev-11-1 \
    #     cuda-toolkit-11-3-config-common \
    #     cuda-toolkit-11-config-common \
    #     cuda-toolkit-config-common \
    #     libcublas-11-1=11.3.0.106-1 \
    #     libcublas-dev-11-1=11.3.0.106-1 \
    #     libnvinfer8=8.0.0-1+cuda11.0 \
    #     libnvinfer-dev=8.0.0-1+cuda11.0 \
    #     libnvinfer-plugin8=8.0.0-1+cuda11.0 \
    #     libnvinfer-plugin-dev=8.0.0-1+cuda11.0

NVINFER_VERSION=${NVINFER_VERSION:-8.5.3-1}
    
    apt_install \
        libnvinfer8=${NVINFER_VERSION}+cuda11.8 \
        libnvinfer-dev=${NVINFER_VERSION}+cuda11.8 \
        libnvinfer-plugin8=${NVINFER_VERSION}+cuda11.8 \
        libnvinfer-plugin-dev=${NVINFER_VERSION}+cuda11.8
    
    
    (cd /usr/lib/x86_64-linux-gnu && \
         ln -s libnvinfer_plugin.so.8 libnvinfer_plugin.so.7 && \
         ln -s libnvinfer.so.8 libnvinfer.so.7)


}

function install_docs() {

    [ "$Y_NV_CUDA_DOCS" = 1 ] || return 0

    apt_install \
        cuda-documentation-11-1
    

}

function install_demo() {

    [ "$Y_NV_CUDA_DEMO" = 1 ] || return 0

    apt_install \
        cuda-demo-suite-11-1
    

}

function install_samples() {

    [ "$Y_NV_CUDA_SAMPLES" = 1 ] || return 0

    apt_install \
        cuda-samples-11-1
    

}

function install_nvtop() {

    [ "$Y_NV_CUDA_NVTOP" = 1 ] || return 0

    [ -f /etc/default/keyboard ] || \
    cat <<EOK > /etc/default/keyboard
# Check /usr/share/doc/keyboard-configuration/README.Debian for
# documentation on what to do after having modified this file.

# The following variables describe your keyboard and can have the same
# values as the XkbModel, XkbLayout, XkbVariant and XkbOptions options
# in /etc/X11/xorg.conf.

XKBMODEL="pc105"
XKBLAYOUT="${Y_KBD_LAYOUT_SET:="us"}"
XKBVARIANT="intl"
XKBOPTIONS=""

# If you don't want to use the XKB layout on the console, you can
# specify an alternative keymap.  Make sure it will be accessible
# before /usr is mounted.
# KMAP=/etc/console-setup/defkeymap.kmap.gz
BACKSPACE="guess"

EOK

    apt_install \
        cmake \
        libdrm-dev \
        libudev-dev \
        libncurses5-dev \
        libncursesw5-dev \
        git

    mkdir -p /usr/local/src/
    cd       /usr/local/src/
    
    git clone https://github.com/Syllo/nvtop.git
    mkdir -p nvtop/build && cd nvtop/build
    
    cmake .. -DNVML_RETRIEVE_HEADER_ONLINE=True
    make
    make install

    cd

    rm -rf /usr/local/src/nvtop
    

}

function config_blas() {

    [ "$Y_NV_CUDA_BLAS" = 1 ] || return 0

    # @see:https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/config_R_cuda.sh#L35     

    # We don't want to set LD_PRELOAD globally
    #ENV LD_PRELOAD=/usr/local/cuda/lib64/libnvblas.so

    # Instead, we will set it before calling R, Rscript, or RStudio:
    
    mv /usr/local/bin/R /usr/local/bin/R_
    cat <<'EOR' > /usr/local/bin/R
#!/bin/bash
LD_PRELOAD=/usr/local/cuda/lib64/libnvblas.so /usr/local/bin/R_ "$@"
EOR
    chmod +x /usr/local/bin/R
    
    mv /usr/local/bin/Rscript /usr/local/bin/Rscript_
    cat <<'EOR' > /usr/local/bin/Rscript
#!/bin/bash
LD_PRELOAD=/usr/local/cuda/lib64/libnvblas.so /usr/local/bin/Rscript_ "$@"
EOR
    chmod +x /usr/local/bin/Rscript

    cat <<'EOR' > /etc/services.d/rstudio/run
#!/usr/bin/with-contenv bash
## load /etc/environment vars first:
for line in $( cat /etc/environment ) ; do export $line ; done
export LD_PRELOAD=/usr/local/cuda/lib64/libnvblas.so
exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0
EOR
    
}





function check_cuda() {
    
    [ "$Y_NV_CUDA_CHECK" = 1 ] || return 0

    
    cat <<EOF || true
## //////////////////////////////////////////
##
# CUDA ENV
#

CUDA_HOME=$CUDA_HOME
CUDA_VERSION=$CUDA_VERSION
NVIDIA_REQUIRE_CUDA=$NVIDIA_REQUIRE_CUDA
NV_CUDNN_VERSION=$NV_CUDNN_VERSION
NV_CUDA_CUDART_VERSION=$NV_CUDA_CUDART_VERSION
NV_CUDA_COMPAT_PACKAGE=$NV_CUDA_COMPAT_PACKAGE
NV_LIBCUBLAS_VERSION=$NV_LIBCUBLAS_VERSION

--
PATH=$PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH
LIBRARY_PATH=$LIBRARY_PATH
--

nvidia-smi: $(which nvidia-smi)
nvcc: $(which nvcc)
nvtop: $(which nvtop)

## //////////////////////////////////////////
EOF

    set -x

    which nvcc   || true
    nvcc -V      || true

#   Rscript -e 'sessionInfo()'   || true
    
    set +x
    
}


function clean_up() {
    :
}



function main() {
    
    [ "$Y_NV_ANY_SUPPORT" = 1 ] || return 0

    env_dump $@

    [ "$Y_NV_CUDA_SUPPORT" = 1 ] || return 0

    install_compiler
    install_tools
    install_libraries
    # install_docs
    # install_demo
    # install_samples
    install_nvtop
    
    config_blas
    check_cuda

    clean_up


}

main $@
