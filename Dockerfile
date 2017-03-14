#FROM debian:jessie
FROM ubuntu:12.04
MAINTAINER albert

RUN apt-get update
RUN apt-get install -y bzr bzr-gtk bzrtools python python-egenix-mxdatetime python-dateutil python-pybabel python-openid python-feedparser python-lxml python-libxml2 python-libxslt1 python-psycopg2 python-libxml2 python-libxslt1 python-imaging python-gdata python-ldap python-reportlab python-pyparsing python-simplejson python-pydot python-webdav graphviz python-werkzeug python-matplotlib python-vatnumber python-numpy python-pychart python-egenix-mxdatetime python-vobject python-zsi python-xlwt python-hippocanvas python-profiler python-dev python-setuptools postgresql postgresql-client-common python-yaml python-mako python-passlib xsltproc xmlstarlet python-soappy python-qrencode python-suds python-pip && pip install xlutils


# Install Odoo
ENV ODOO_VERSION 6.1
ENV ODOO_RELEASE 20140210
COPY odd_aa .
COPY odd_ab .
COPY odd_ac .
RUN cat odd_* > odoo.deb
RUN set -x;
RUN dpkg --force-depends -i odoo.deb
        RUN apt-get update \
        && apt-get -y install -f --no-install-recommends 
        RUN rm -rf /var/lib/apt/lists/* odoo.deb
# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./openerp-server.conf /etc/odoo/

RUN mkdir -p /home/odoo
WORKDIR /home/odoo
RUN useradd odoo -u 1000 -s /bin/bash
RUN chown odoo -R /home/odoo 
ENV HOME /home/odoo
COPY addons /addons

RUN chown -R odoo /addons
RUN chown odoo /etc/odoo/openerp-server.conf

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
