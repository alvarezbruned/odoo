FROM albertalvarezbruned/odoo:base


#COPY openerp_6.1-20140210-004940-1_all.deb /tmp
#RUN mv /tmp/openerp_6.1-20140210-004940-1_all.deb /tmp/open.deb

COPY odd_* /tmp
RUN cat /tmp/odd_* > open.deb


RUN chmod +x /tmp/open.deb
RUN dpkg --force-depends -i /tmp/open.deb
        RUN apt-get update \
        && apt-get -y install -f --no-install-recommends
        RUN rm -rf /var/lib/apt/lists/* /tmp/open.deb


RUN mkdir -p /home/odoo
WORKDIR /home/odoo
RUN useradd odoo -u 1000 -s /bin/bash
RUN chown odoo -R /home/odoo
ENV HOME /home/odoo
RUN chown -R odoo /addons
RUN chown odoo /etc/odoo/openerp-server.conf
RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]
EXPOSE 8069 8071
ENV OPENERP_SERVER /etc/odoo/openerp-server.conf
USER odoo


ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]
