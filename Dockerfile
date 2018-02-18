FROM ubuntu:14.04

RUN apt-get update && apt-get install -y curl
RUN apt-get -y install python
RUN apt-get -f install -y

RUN apt-get install -y postgresql-client \
 python-dateutil \
 python-feedparser \
 python-gdata \
 python-ldap \
 python-libxslt1 \
 python-lxml \
 python-mako \
 python-openid \
 python-psycopg2 \
 python-pybabel \
 python-pychart \
 python-pydot \
 python-pyparsing \ 
 python-reportlab \ 
 python-simplejson \
 python-tz \
 python-vatnumber \ 
 python-vobject \
 python-webdav \
 python-werkzeug \
 python-xlwt \
 python-yaml \
 python-zsi

RUN apt-get -f install -y
RUN curl -fsSL http://nightly.odoo.com/old/openerp-6.1/6.1.0/openerp_6.1-1-1_all.deb -o /tmp/open.deb

RUN chmod +x /tmp/open.deb
RUN dpkg --force-depends -i /tmp/open.deb
        RUN apt-get update \
        && apt-get -y install -f --no-install-recommends
        RUN rm -rf /var/lib/apt/lists/* /tmp/open.deb

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
