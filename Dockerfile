FROM ubuntu:12.04

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update
RUN apt-get install -y --no-install-recommends
RUN apt-get install -y --no-install-recommends ca-certificates
RUN apt-get install -y --no-install-recommends curl
RUN apt-get install -y --no-install-recommends node-less
#RUN apt-get install -y --no-install-recommends node-clean-css
RUN apt-get install -y --no-install-recommends python-gevent
RUN apt-get install -y --no-install-recommends python-pip
RUN apt-get install -y --no-install-recommends python-pyinotify
RUN apt-get install -y --no-install-recommends python-renderpm
RUN apt-get install -y --no-install-recommends python-support
RUN curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb
RUN echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c -
RUN dpkg --force-depends -i wkhtmltox.deb
RUN apt-get -y install -f --no-install-recommends
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm
RUN rm -rf /var/lib/apt/lists/* wkhtmltox.deb
RUN pip install psycogreen==1.0


# Install Odoo
#ENV ODOO_VERSION 8.0
#ENV ODOO_RELEASE 20170207
#RUN set -x; \
#        curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
#        && echo 'cd8c1dc9d2ddf5a538381eed85871a2e343ec8ae odoo.deb' | sha1sum -c - \
#        && dpkg --force-depends -i odoo.deb \
#        && apt-get update \
#        && apt-get -y install -f --no-install-recommends \
#        && rm -rf /var/lib/apt/lists/* odoo.deb
RUN wget http://nightly.openerp.com/6.1/releases/openerp-6.1-1.tar.gz
RUN mkdir /opt/openerp
RUN mv openerp-6.1-1.tar.gz /opt/openerp
RUN tar xvf /opt/openerp/openerp-6.1-1.tar.gz
RUN chown -R openerp: *

RUN cp /opt/openerp/server/install/openerp-server.conf /etc/
RUN chown openerp: /etc/openerp-server.conf
RUN chmod 640 /etc/openerp-server.conf
# RUN su - openerp -s /bin/bash
# RUN /opt/openerp/server/openerp-server

# Copy entrypoint script and Odoo configuration file
# COPY ./entrypoint.sh /
# COPY ./openerp-server.conf /etc/odoo/
# RUN chown odoo /etc/odoo/openerp-server.conf

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
# RUN mkdir -p /mnt/extra-addons \
#         && chown -R odoo /mnt/extra-addons
# VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071 5432

# Set the default config file
# ENV OPENERP_SERVER /etc/odoo/openerp-server.conf

# Set default user when running the container
USER odoo

# ENTRYPOINT ["su - openerp -s /bin/bash"]
CMD ["/opt/openerp/server/openerp-server"]
