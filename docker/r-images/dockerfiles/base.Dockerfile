FROM ubdems/dve-sample-r.anchor

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://gitlab.com/ub-dems-public/ds-labs/dve-sample-r" \
      org.opencontainers.image.vendor="ub-dems" \
      org.opencontainers.image.authors="DsUser DEMS <dsuser.dems@gmail.com>"

ENV TERM=xterm

COPY scripts /rocker_scripts

RUN /rocker_scripts/init_ubs-userconf.sh
RUN /rocker_scripts/install_ubs-base.sh

EXPOSE 8787

CMD ["/init"]
#CMD ["R"]
