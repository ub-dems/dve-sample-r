FROM ubdems/dve-sample-r.base

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://gitlab.com/ub-dems-public/ds-labs/dve-sample-r" \
      org.opencontainers.image.vendor="ubdems" \
      org.opencontainers.image.authors="DsUser DEMS <dsuser.dems@gmail.com>"

COPY scripts /rocker_scripts

RUN /rocker_scripts/install_ubs-runtime.sh
