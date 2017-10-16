# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-customizable:0.9.25

MAINTAINER Kevin Meredith <kevin@meredithkm.info>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features. 
#
# N.B. these images are based on https://github.com/phusion/baseimage-docker, 
# so anything it provides is also automatically on board in the images below 
# (e.g. older versions of Ruby, Node, Python).  
# 
# Uncomment the features you want:
#
#   Ruby support
#RUN /pd_build/ruby-2.0.*.sh
#RUN /pd_build/ruby-2.1.*.sh
#RUN /pd_build/ruby-2.2.*.sh
#RUN /pd_build/ruby-2.3.*.sh
#RUN /pd_build/ruby-2.4.*.sh
#RUN /pd_build/jruby-9.1.*.sh
#   Python support.
RUN /pd_build/python.sh
#   Node.js and Meteor standalone support.
#   (not needed if you already have the above Ruby support)
#RUN /pd_build/nodejs.sh

# ...put your own build instructions here...

RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:privacyidea/privacyidea \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y python-privacyidea python-pip libmysqlclient-dev

RUN pip install --upgrade pip
RUN pip install MySQL-python

RUN mkdir /etc/privacyidea
RUN chown app:app /etc/privacyidea

RUN rm -f /etc/nginx/sites-enabled/default
ADD ./nginx/sites-enabled/privacyidea.conf /etc/nginx/sites-enabled/privacyidea.conf
RUN rm -f /etc/service/nginx/down

VOLUME /etc/privacyidea/

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
