FROM albertalvarezbruned/odoo:6.1

RUN curl -fsSL http://nightly.odoo.com/old/openerp-6.1/6.1.0/openerp_6.1-1-1_all.deb -o /tmp/open.deb

RUN chmod +x /tmp/open.deb
RUN dpkg --force-depends -i /tmp/open.deb
        RUN apt-get update \
        && apt-get -y install -f --no-install-recommends
        RUN rm -rf /var/lib/apt/lists/* /tmp/open.deb


ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]
