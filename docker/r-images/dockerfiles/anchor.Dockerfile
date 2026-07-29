# @see: https://rocker-project.org/images/
# @see: https://hub.docker.com/u/rocker

FROM rocker/geospatial:4.5.2

# FROM rocker/tidyverse:4.5.2
# FROM rocker/verse:4.5.2
# FROM rocker/geospatial:4.5.2
# FROM rocker/ml:4.5.2
# FROM rocker/ml-verse:4.5.2

# @see: https://github.com/rocker-org/rocker-versioned2/pkgs/container/verse/versions
# @see: https://hub.docker.com/r/rocker/verse/tags
# FROM rocker/verse:latest

LABEL org.opencontainers.image.vendor="ubdems" \
      org.opencontainers.image.base.name="rocker/geospatial:4.5.2" \
      org.opencontainers.image.title="ubdems/dve-sample-r.anchor" \
      org.opencontainers.image.source="https://gitlab.com/ub-dems-public/ds-labs/dve-sample-r" \
      org.opencontainers.image.authors="DEMS/datalab <dsuser.dems@gmail.com>" \
      org.opencontainers.image.description="TODO:description" \
      org.opencontainers.image.licenses="GPL-2.0-or-later" \
      it.unimib.datalab.type="project.anchor" \
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
