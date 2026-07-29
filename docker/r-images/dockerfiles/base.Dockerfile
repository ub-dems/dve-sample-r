FROM ubdems/dve-sample-r.cuda
#FROM ubdems/dve-sample-r.anchor

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
      it.unimib.datalab.from="2026-03-16" \
      it.unimib.datalab.until="2222-02-02" \
      it.unimib.datalab.owner="ab21010" \
      it.unimib.datalab.cdc="ds-101" \
      it.unimib.datalab.tags="none"

ENV IMG_TYPE base

# from makefile (autodetect) - no default

ARG  Y_WORK_DIR
ENV  X_WORK_DIR=$Y_WORK_DIR



#ARG DEBIAN_FRONTEND=noninteractive

ARG  Y_SHELL_SET=/bin/bash
ENV  SHELL=$Y_SHELL_SET



ARG  Y_EDITOR_SET=vim
ENV  EDITOR=$Y_EDITOR_SET
ARG  Y_VISUAL_SET=vim
ENV  VISUAL=$Y_VISUAL_SET
ARG  Y_PAGER_SET=less
ENV  PAGER=$Y_PAGER_SET




ARG  Y_TERM_SET=xterm-256color
#ENV  TERM=$Y_TERM_SET

ARG  Y_TZ_SET=Europe/Rome
ENV  TZ=$Y_TZ_SET
RUN  echo "$TZ" > /etc/timezone


ARG  Y_KBD_LAYOUT_SET=it

COPY scripts/base /rocker_scripts
COPY build.conf   /etc/build.conf
ARG  Y_BUILD_CONF=/etc/build.conf
ENV  X_BUILD_CONF=$Y_BUILD_CONF


ARG  Y_DEBUG_ENV=0
ENV  X_DEBUG_ENV=$Y_DEBUG_ENV

# init user configuration 
RUN /rocker_scripts/init_ubs-userconf.sh

# commons
RUN /rocker_scripts/install_ubs-commons.sh
RUN /rocker_scripts/install_ubs-utils.sh

# emacs support

ENV NO_AT_BRIDGE=1

# cursor support

ENV CAN_LAUNCH_AS_ROOT=1

# python support

ENV VIRTUAL_ENV=/opt/venv
ENV VIRTUAL_IMG=/opt/venv.img

ENV PYENV_ROOT=/opt/pyenv
ENV PIPX_GLOBAL_HOME=/opt/pipx
ENV PIPX_GLOBAL_BIN_DIR=/opt/pipx/bin
ENV POETRY_HOME=/opt/poetry
ENV PYVENVS_ROOT=/opt/pyvenvs
ENV GLOBAL_VENV=/opt/pyvenvs/global

ENV FNM_ROOT=/opt/fnm
ENV NODE_ROOT=/opt/nodejs
ENV FNM_DIR=$NODE_ROOT/.fnm
ENV RUST_ROOT=/opt/rust
ENV RUSTUP_HOME=/opt/rust
ENV CARGO_HOME=/opt/cargo

#RUN mkdir -p ${POETRY_HOME}/bin ${PIPX_GLOBAL_HOME} ${PIPX_GLOBAL_BIN_DIR} ${PYVENVS_ROOT} ${GLOBAL_VENV}/bin ${PYENV_ROOT}/bin ${PYENV_ROOT}/shims ${PYENV_ROOT}/plugins/pyenv-virtualenv/shims
#RUN echo "# +++ #base(123): zzz"
ENV PATH=${POETRY_HOME}/bin:${PIPX_GLOBAL_BIN_DIR}:${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PYENV_ROOT}/plugins/pyenv-virtualenv/shims:${GLOBAL_VENV}/bin:${NODE_ROOT}/bin:${CARGO_HOME}/bin:${RUSTUP_HOME}/bin:${PATH}
RUN echo "# +++ #base(pre): PATH=${PATH}"

RUN /rocker_scripts/install_ubs-rs_rust.sh
RUN /rocker_scripts/install_ubs-js_node.sh
RUN /rocker_scripts/install_ubs-js_code.sh

RUN /rocker_scripts/install_ubs-py_base.sh
RUN /rocker_scripts/install_ubs-py_system.sh
RUN /rocker_scripts/install_ubs-py_pyenv.sh
RUN /rocker_scripts/install_ubs-py_poetry.sh
RUN /rocker_scripts/install_ubs-py_lang.sh
RUN /rocker_scripts/install_ubs-py_jupyter.sh

RUN /rocker_scripts/install_ubs-re_seal.sh

# clean up
RUN /rocker_scripts/install_ubs-clean.sh

RUN echo "# +++ #base(post): PATH=${PATH}"
RUN echo "# +++ #base(bash): PATH=$(bash --login -i -c 'printf \"%s\" "$PATH"' | tail -n1)"

EXPOSE 8888
EXPOSE 8787
EXPOSE 8686
EXPOSE 8080

#CMD ["/init"]
#CMD ["R"]

COPY scripts/start /etc/dsbox/runtime/
RUN  chmod -R a+x  /etc/dsbox/runtime/
ENTRYPOINT ["/etc/dsbox/runtime/runtime_entrypoint.sh"]
