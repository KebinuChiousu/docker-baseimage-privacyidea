# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.22

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"].

MAINTAINER Kevin Meredith <kevin@meredithkm.info>

# Install Phusion Passenger PGP key and add HTTPS support for APT
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN apt-get install -y apt-transport-https ca-certificates

# Add Phusion Passenger APT repository
RUN echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list

RUN apt-get update
RUN apt-get install -y nginx-extras passenger

RUN passenger-config validate-install

RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:privacyidea/privacyidea \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y python-privacyidea python-pip libmysqlclient-dev

RUN pip install --upgrade pip
RUN pip install MySQL-python

RUN mkdir /var/log/privacyidea
RUN touch /var/log/privacyidea/privacyidea.log
RUN chown nobody /var/log/privacyidea/privacyidea.log
RUN chmod 644 /var/log/privacyidea/privacyidea.log

RUN rm -f /etx/nginx/nginx.conf
RUN rm -f /etc/nginx/sites-enabled/default

ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./nginx/sites-enabled/pi /etc/nginx/sites-enabled/pi
ADD ./pi /var/www/pi

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Setup nginx service
RUN mkdir /etc/service/nginx
COPY service/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

VOLUME /etc/privacyidea
EXPOSE 80

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
