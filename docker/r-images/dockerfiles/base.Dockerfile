FROM ubdems/dve-sample-r.anchor

LABEL org.opencontainers.image.vendor="ubdems" \
      org.opencontainers.image.base.name="ubdems/dve-sample-r.anchor" \
      org.opencontainers.image.title="ubdems/dve-sample-r.base" \
      org.opencontainers.image.source="https://gitlab.com/ub-dems-public/ds-labs/dve-sample-r" \
      org.opencontainers.image.authors="DEMS/datalab <dsuser.dems@gmail.com>" \
      org.opencontainers.image.description="TODO:description" \
      org.opencontainers.image.licenses="GPL-2.0-or-later" \
      it.unimib.datalab.type="project.base" \
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

ENV TERM=xterm

COPY scripts/base /rocker_scripts
COPY build.conf   /etc/build.conf
ARG  Y_BUILD_CONF=/etc/build.conf

ARG  Y_DEBUG_ENV=1
ENV  X_DEBUG_ENV $Y_DEBUG_ENV

# init user configuration 
RUN /rocker_scripts/init_ubs-userconf.sh

# commons
RUN /rocker_scripts/install_ubs-commons.sh
RUN /rocker_scripts/install_ubs-utils.sh

# python support

ENV PYENV_ROOT  /opt/pyenv
ENV POETRY_HOME /opt/poetry
RUN mkdir -p ${POETRY_HOME}/bin ${PYENV_ROOT}/bin ${PYENV_ROOT}/shims ${PYENV_ROOT}/plugins/pyenv-virtualenv/shims
ENV PATH  ${POETRY_HOME}/bin:${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PYENV_ROOT}/plugins/pyenv-virtualenv/shims:${PATH}
RUN echo "# +++ #base(pre): PATH=${PATH}"

RUN /rocker_scripts/install_ubs-py_system.sh
RUN /rocker_scripts/install_ubs-py_pyenv.sh
RUN /rocker_scripts/install_ubs-py_poetry.sh
RUN /rocker_scripts/install_ubs-py_lang.sh
RUN /rocker_scripts/install_ubs-py_jupyter.sh

# clean up
RUN /rocker_scripts/install_ubs-clean.sh

RUN echo "# +++ #base(post): PATH=${PATH}"
RUN echo "# +++ #base(bash): PATH=$(bash --login -i -c 'printf \"%s\" "$PATH"' | tail -n1)"

EXPOSE 8787

CMD ["/init"]
#CMD ["R"]
