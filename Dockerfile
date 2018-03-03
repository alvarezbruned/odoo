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

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
RUN mkdir -p /etc/odoo
COPY ./openerp-server.conf /etc/odoo/
COPY addons /addons


##RUN mkdir -p /home/odoo
##WORKDIR /home/odoo
##RUN useradd odoo -u 1000 -s /bin/bash
##RUN chown odoo -R /home/odoo
##ENV HOME /home/odoo
##RUN chown -R odoo /addons
##RUN chown odoo /etc/odoo/openerp-server.conf
##RUN mkdir -p /mnt/extra-addons \
##        && chown -R odoo /mnt/extra-addons
##VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]
##EXPOSE 8069 8071
##ENV OPENERP_SERVER /etc/odoo/openerp-server.conf
##USER odoo

