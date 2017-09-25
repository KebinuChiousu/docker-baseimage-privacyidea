# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.22

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

MAINTAINER Kevin Meredith <kevin@meredithkm.info>


RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:privacyidea/privacyidea \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y python-privacyidea python-pip libmysqlclient-dev uwsgi-plugin-python uwsgi

RUN pip install --upgrade pip
RUN pip install MySQL-python

RUN groupadd -g 500 privacyidea
RUN useradd -u 500 privacyidea -g privacyidea
RUN mkdir -p /etc/privacyidea
RUN chown privacyidea:privacyidea /etc/privacyidea
RUN chmod 775 /etc/privacyidea

# Add additional binaries into PATH for convenience
#ENV PATH=$PATH:/usr/local/openresty/luajit/bin/:/usr/local/openresty/nginx/sbin/:/usr/local/openresty/bin/

# Setup uwsgi service
RUN mkdir /etc/service/uwsgi
COPY service/uwsgi.sh /etc/service/uwsgi/run
RUN chmod +x /etc/service/uwsgi/run

RUN mkdir -p /var/log/privacyidea

EXPOSE 3031
VOLUME /etc/privacyidea/

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

