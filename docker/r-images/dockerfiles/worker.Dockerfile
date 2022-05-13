FROM dve-sample-r.runtime

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://gitlab.com/ub-dems-public/ds-labs/dve-sample-r" \
      org.opencontainers.image.vendor="ubdems" \
      org.opencontainers.image.authors="DsUser DEMS <dsuser.dems@gmail.com>"


ENV  DIRPATH=/worker
WORKDIR $DIRPATH


ENV RENV_VERSION 0.15.4
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

COPY renv.lock renv.lock
RUN R -e 'renv::restore()'

# @todo: add podman build cache
#RUN R -e 'renv::isolate()'

COPY . .


CMD exec ./worker.sh $WORKER_ARGS

