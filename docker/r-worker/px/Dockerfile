FROM danieldent/nginx-ssl-proxy:latest
#FROM fsouza/docker-ssl-proxy:latest
#RUN find / \( -uid 65534 \)  -ls 2>/dev/null || true
#RUN cat /etc/passwd
#RUN chown -R root:root /etc/nginx
COPY proxy.conf /etc/nginx/conf.d/default.conf
COPY bin/ConvertLetsPemToPfx.sh /usr/local/bin
RUN  chmod a+x /usr/local/bin/ConvertLetsPemToPfx.sh



