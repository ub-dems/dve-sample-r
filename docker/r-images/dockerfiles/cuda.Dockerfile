FROM ubdems/dve-sample-r.anchor

LABEL org.opencontainers.image.vendor="ubdems" \
      org.opencontainers.image.base.name="ubdems/dve-sample-r.cuda" \
      org.opencontainers.image.title="ubdems/dve-sample-r.cuda" \
      org.opencontainers.image.source="https://gitlab.com/ub-dems-public/ds-labs/dve-sample-r" \
      org.opencontainers.image.authors="DEMS/datalab <dsuser.dems@gmail.com>" \
      org.opencontainers.image.description="TODO:description" \
      org.opencontainers.image.licenses="GPL-2.0-or-later" \
      it.unimib.datalab.type="project.cuda" \
      it.unimib.datalab.name="dve-sample-r" \
      it.unimib.datalab.group="ub-dems-public/ds-labs" \
      it.unimib.datalab.path="ub-dems-public/ds-labs/dve-sample-r" \
      it.unimib.datalab.schema="dve:1.0" \
      it.unimib.datalab.lang="R" \
      it.unimib.datalab.from="2022-06-01" \
      it.unimib.datalab.until="2222-02-02" \
      it.unimib.datalab.owner="ab21010" \
      it.unimib.datalab.cdc="ds-101" \
      it.unimib.datalab.tags="none"


#ARG DEBIAN_FRONTEND=noninteractive


ENV NV_CUDNN_VERSION 8.6.0.163
ENV NV_CUDNN_PACKAGE_NAME "libcudnn8"
ENV NV_CUDNN_PACKAGE_LIST "libcudnn8 libcudnn8-dev"

ENV NV_CUDNN_PACKAGE "libcudnn8=$NV_CUDNN_VERSION-1+cuda11.8"
ENV NV_CUDNN_PACKAGE_DEV "libcudnn8-dev=$NV_CUDNN_VERSION-1+cuda11.8"

ENV NV_NVINFER_VERSION 8.6.0.12
ENV NV_NVINFER_PACKAGE_NAME "libnvinfer8"
ENV NV_NVINFER_PACKAGE_ALIAS "libnvinfer7"
ENV NV_NVINFER_PACKAGE_LIST "libnvinfer8 libnvinfer-dev libnvinfer-headers-dev libnvinfer-headers-plugin-dev libnvinfer-plugin8 libnvinfer-plugin-dev"

ENV NV_NVINFER_VER "$NV_NVINFER_VERSION-1+cuda11.8"

ENV NV_NVINFER_PACKAGES "libnvinfer8=$NV_NVINFER_VER libnvinfer-dev=$NV_NVINFER_VER libnvinfer-headers-dev=$NV_NVINFER_VER libnvinfer-headers-plugin-dev=$NV_NVINFER_VER libnvinfer-plugin8=$NV_NVINFER_VER libnvinfer-plugin-dev=$NV_NVINFER_VER"


ENV NV_NVCC_PACKAGE_NAME "cuda-nvcc-11-8"
ENV NV_NVCC_PACKAGE "$NV_NVCC_PACKAGE_NAME"


ENV NV_DRIVER_COMP 470
ENV NV_DRIVER_DIST 520

ENV NV_DRIVER_LINE "$NV_DRIVER_COMP"



ARG  Y_TERM_SET=xterm-256color
ENV  TERM $Y_TERM_SET

ARG  Y_TZ_SET=Europe/Rome
ENV  TZ $Y_TZ_SET
RUN  echo "$TZ" > /etc/timezone


ARG  Y_KBD_LAYOUT_SET=it

RUN  mkdir -p     /etc/ubs
COPY scripts/cuda /rocker_scripts
COPY cuda.conf    /etc/ubs/cuda.conf
ARG  Y_BUILD_CONF=/etc/ubs/cuda.conf

ARG  Y_DEBUG_ENV=0
ENV  X_DEBUG_ENV $Y_DEBUG_ENV

# cuda
RUN /rocker_scripts/install_ubs-cuda-11-470.sh
RUN /rocker_scripts/install_ubs-cuda-12-560.sh



RUN echo "# +++ #cuda(post): PATH=${PATH}"
RUN echo "# +++ #cuda(bash): PATH=$(bash --login -i -c 'printf \"%s\" "$PATH"' | tail -n1)"

EXPOSE 8787

CMD ["/init"]
#CMD ["R"]
