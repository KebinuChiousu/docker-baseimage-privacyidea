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
    && apt-get install -y python-privacyidea python-pip libmysqlclient-dev nginx-full uwsgi

RUN pip install --upgrade pip
RUN pip install MySQL-python

RUN groupadd -g 500 privacyidea
RUN useradd -u 500 privacyidea -g privacyidea

# Add additional binaries into PATH for convenience
#ENV PATH=$PATH:/usr/local/openresty/luajit/bin/:/usr/local/openresty/nginx/sbin/:/usr/local/openresty/bin/

# Setup openresty service
#RUN mkdir /etc/service/openresty
#COPY openresty.sh /etc/service/openresty/run
#RUN chmod +x /etc/service/openresty/run

EXPOSE 80
VOLUME /etc/privacyidea/
VOLUME /etc/uwsgi/

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

