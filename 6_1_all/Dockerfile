FROM albertalvarezbruned/odoo:base

COPY odd_aa /tmp 
COPY odd_ab /tmp 
COPY odd_ac /tmp 
COPY odd_ad /tmp 
COPY odd_ae /tmp 
COPY odd_af /tmp 
COPY odd_ag /tmp 
COPY odd_ah /tmp 
COPY odd_ai /tmp 
COPY odd_aj /tmp 
COPY odd_ak /tmp 
COPY odd_al /tmp 
COPY odd_am /tmp 
COPY odd_an /tmp 
RUN cat /tmp/odd_* > /tmp/open.deb


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
