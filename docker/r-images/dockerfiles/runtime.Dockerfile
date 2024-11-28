FROM ubdems/dve-sample-r.base

LABEL org.opencontainers.image.vendor="ubdems" \
      org.opencontainers.image.base.name="ubdems/dve-sample-r.base" \
      org.opencontainers.image.title="ubdems/dve-sample-r.runtime" \
      org.opencontainers.image.source="https://gitlab.com/ub-dems-public/ds-labs/dve-sample-r" \
      org.opencontainers.image.authors="DEMS/datalab <dsuser.dems@gmail.com>" \
      org.opencontainers.image.description="TODO:description" \
      org.opencontainers.image.licenses="GPL-2.0-or-later" \
      it.unimib.datalab.type="project.runtime" \
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

COPY scripts/runtime /rocker_scripts
#COPY scripts/setup   /rocker_scripts

RUN /rocker_scripts/install_ubs-runtime.sh
