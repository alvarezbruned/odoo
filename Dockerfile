#FROM debian:jessie
FROM ubuntu:12.04
MAINTAINER albert
ENV USUARIO u1617s2
# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
#RUN set -x; \
#        apt-get update \
#        && apt-get install -y --no-install-recommends \
#            ca-certificates \
#            curl \
#            node-less \
#            node-clean-css \
#            python-gevent \
#            python-pip \
#            python-pyinotify \
#            python-renderpm \
#            python-support \
#        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
#        && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
#        && dpkg --force-depends -i wkhtmltox.deb \
#        && apt-get -y install -f --no-install-recommends \
#        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
#        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb \
#        && pip install psycogreen==1.0
#

RUN apt-get update
RUN apt-get install -y bzr bzr-gtk bzrtools python python-egenix-mxdatetime python-dateutil python-pybabel python-openid python-feedparser python-lxml python-libxml2 python-libxslt1 python-psycopg2 python-libxml2 python-libxslt1 python-imaging python-gdata python-ldap python-reportlab python-pyparsing python-simplejson python-pydot python-webdav graphviz python-werkzeug python-matplotlib python-vatnumber python-numpy python-pychart python-egenix-mxdatetime python-vobject python-zsi python-xlwt python-hippocanvas python-profiler python-dev python-setuptools postgresql postgresql-client-common python-yaml python-mako python-passlib xsltproc xmlstarlet python-soappy python-qrencode python-suds python-pip && pip install xlutils


# Install Odoo
ENV ODOO_VERSION 6.1
ENV ODOO_RELEASE 20140210
COPY odoo.deb .

RUN set -x;
#        curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
#         echo 'cd8c1dc9d2ddf5a538381eed85871a2e343ec8ae odoo.deb' | sha1sum -c - \
RUN dpkg --force-depends -i odoo.deb
        RUN apt-get update \
        && apt-get -y install -f --no-install-recommends 
        RUN rm -rf /var/lib/apt/lists/* odoo.deb
# Copy entrypoint script and Odoo configuration file
ENV USUARIO odoo
COPY ./entrypoint.sh /
COPY ./openerp-server.conf /etc/odoo/

RUN mkdir -p /home/odoo
WORKDIR /home/odoo
RUN useradd odoo -u 1000 -s /bin/bash
RUN chown odoo -R /home/odoo 
#USER odoo
ENV HOME /home/odoo

#RUN chown odoo /etc/odoo/openerp-server.conf

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]


# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV OPENERP_SERVER /etc/odoo/openerp-server.conf

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]
