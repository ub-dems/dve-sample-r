FROM dve-sample-r.runtime

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://gitlab.com/ub-dems-public/ds-labs/dve-sample-r" \
      org.opencontainers.image.vendor="ubdems" \
      org.opencontainers.image.authors="DsUser DEMS <dsuser.dems@gmail.com>"

ENV  DIRPATH=/worker
WORKDIR $DIRPATH
COPY . .
CMD exec ./worker.sh $WORKER_ARGS

