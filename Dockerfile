FROM ubuntu:14.04



RUN apt-get update && apt-get install -y curl
RUN apt-get -y install python
RUN apt-get -f install -y

RUN apt-get install -y xvfb libfontconfig wkhtmltopdf

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



