#!/bin/sh
uwsgi --socket 0.0.0.0:3031 --plugin python --wsgi-file /etc/privacyidea/privacyideaapp.py --master --processes 4 --threads 2
